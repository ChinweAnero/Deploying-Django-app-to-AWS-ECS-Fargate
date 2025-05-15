terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
}

resource "aws_security_group" "sec_group" {
  name = var.name
  vpc_id = var.vpc_id

  ingress {
    protocol  = "tcp"
    from_port = var.ingress_port
    to_port   = var.ingress_port
    cidr_blocks = var.ingress_cidr_block
    security_groups = var.security_group
  }


  egress {
    from_port   = var.egress_port
    to_port     = var.egress_port
    protocol    = "-1"
    cidr_blocks = var.egress_cidr_block
  }
  tags = {
    name = "secGroup"
  }
}


