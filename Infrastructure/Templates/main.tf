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
