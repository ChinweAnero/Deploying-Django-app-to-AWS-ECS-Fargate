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

}
