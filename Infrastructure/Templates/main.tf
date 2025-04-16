terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# AWS Provider
provider "aws" {
  region                   = "eu-west-2"
  shared_credentials_files = ["C:/Users/Chinwe/.aws/credentials"]
}

#*******************Network*****************************
module "VPC" {
  source = "../Modules/Network"
  vpc_cidr_block = var.V_cidr_block
  vpc_name = var.environment
}

module "alb_frontend_Security_group" {
  source = "../Modules/Security_Group"
  vpc_id         = module.VPC.vpc_id
  ingress_cidr_block = ["0.0.0.0/0"]
  ingress_port = 80
  name = "alb-${var.environment}-frontend"
}
module "alb_backend_Security_group" {
  source = "../Modules/Security_Group"
  vpc_id         = module.VPC.vpc_id
  ingress_cidr_block = ["0.0.0.0/0"]
  ingress_port = 80
  name = "alb-${var.environment}-backend"
}

#*********************configuring target groups for server environments********************************#
module "server_target_group_blue" {
  source = "../Modules/LoadBalancer"
  name = "targetg-${var.environment}-server-blue"
  vpc_id = module.VPC.vpc_id
  target_type = "ip"
  port = 80
  protocol = "HTTP"
  healthcheck_path = "/status"
  healthcheck_port = var.server_port
  create_target_group = true

}

module "server_target_group_green" {
  source = "../Modules/LoadBalancer"
  name = "targetg-${var.environment}-server-green"
  vpc_id = module.VPC.vpc_id
  target_type = "ip"
  port = 80
  protocol = "HTTP"
  healthcheck_path = "/status"
  healthcheck_port = var.server_port
  create_target_group = true

}
#*******************************target group for client environments**********************#
module "target_group_client_blue" {
  source = "../Modules/LoadBalancer"
  name   = "targetg-${var.environment}-client-blue"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  healthcheck_path = "/"
  healthcheck_port = var.server_port
}
module "target_group_client_green" {
  source = "../Modules/LoadBalancer"
  name   = "targetg-${var.environment}-client-green"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 80
  protocol = "HTTP"
  target_type = "ip"
  healthcheck_path = "/"
  healthcheck_port = var.server_port
}

#****************************configuring load balancer for both client and server**************************#
module "App_load_balancer_server" {
  source = "../Modules/LoadBalancer"
  name = "App-lb-${var.environment}-backend"
  create_load_balancer = true
  subnets = [module.VPC.public_subnets[0], module.VPC.public_subnets[1]]
  sec_group = module.alb_backend_Security_group.security_group_id
  target_group_arn = module.server_target_group_blue.target_group_arn

  vpc_id = module.VPC.vpc_id
}

module "App_load_balancer_client" {
  source = "../Modules/LoadBalancer"
  name = "App-lb-${var.environment}-frontend"
  create_load_balancer = true
  subnets = [module.VPC.public_subnets[0], module.VPC.public_subnets[1]]
  sec_group = module.alb_frontend_Security_group.security_group_id
  target_group_arn = module.target_group_client_blue.target_group_arn

  vpc_id = module.VPC.vpc_id

}

#****************creating the s3 bucket**********************************#
module "s3" {
  source = "../Modules/S3"
  bucket_name = var.s3_bucket_name
}
#********************ecr for frontend and backend docker images*************#
module "frontend_ecr" {
  source = "../Modules/ECR"
  erc_name = "frontend-ecr-repo"
}
module "backend" {
  source = "../Modules/ECR"
  erc_name = "backend-ecr-repo"
}