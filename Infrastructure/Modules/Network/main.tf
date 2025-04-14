terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}
resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    name = var.vpc_name
  }
}

#*************availability zones in the region************
data "aws_availability_zones" "available_zones" {
  state = "available"
}

#************subnets*****************************************************************#
resource "aws_subnet" "public_subnet" {
  count = 2
  vpc_id = aws_vpc.vpc.id
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 7 , count.index + 1)
  map_public_ip_on_launch = true

  tags = {
    Name = "Pub_Subnet_${count.index}"
  }

}

resource "aws_subnet" "private_subnet_frontend" {
  vpc_id = aws_vpc.vpc.id
  count = 2
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 7, count.index + 3 )
  tags = {
    Name = "frontend_subnet_${count.index}"
  }
}

resource "aws_subnet" "private_subnet_backend" {
  vpc_id = aws_vpc.vpc.id
  count = 2
  availability_zone = data.aws_availability_zones.available_zones.names[count.index]
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 7, count.index + 5)
  tags = {
    Name = "backend_subnet_${count.index}"
  }
}

#***************Internet Gateway*******************************#
resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "project_igw"
  }
}

#***********default route table***************************#
resource "aws_default_route_table" "route_table" {
  default_route_table_id = aws_vpc.vpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "public_route_table_"
  }
}

#*************Elastic ip***********************#
resource "aws_eip" "elastic_ip" {
  tags = {
    Name = "elastic_ip_"
  }
}
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.elastic_ip.id
  subnet_id = aws_subnet.public_subnet[0].id
  tags = {
    Name = "NatGW"
  }

}

#*************private route table**************#
resource "aws_route_table" "private_rt_table" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gateway.id
  }
  tags = {
    Name = "private_route_table"
  }
}

#************associate private subnets with route table**********************#
resource "aws_route_table_association" "rt_table_associate_frontend" {
  count = 2
  route_table_id = aws_route_table.private_rt_table.id
  subnet_id = aws_subnet.private_subnet_frontend[count.index].id
}
resource "aws_route_table_association" "rt_table_association_backend" {
  count = 2
  route_table_id = aws_route_table.private_rt_table.id
  subnet_id = aws_subnet.private_subnet_backend[count.index].id
}

#************associate public subnets with route table******************#
resource "aws_route_table_association" "rt_association_public_subnet" {
  count = 2
  route_table_id = aws_vpc.vpc.main_route_table_id
  subnet_id = aws_subnet.public_subnet[count.index].id
}
