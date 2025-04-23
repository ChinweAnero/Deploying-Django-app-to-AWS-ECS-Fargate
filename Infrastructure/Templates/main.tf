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
#*******************************dynamodb**************************************#
module "dynamodb_table" {
  source = "../Modules/DynamoDB"
  name = "Artifacts_table-${var.environment}"

  hash_key  = var.hash_k
  range_key = var.range

}

#*********************creating ecs role***************************************#
module "role_for_ecs" {
  source = "../Modules/IAM_Roles"
  dynamo_db = [module.dynamodb_table.dynamodb_arn]
  ecs_task_role_name = "ecs-task-${var.iam_role_name}"
  name_ = "ecs-name-${var.iam_role_name}"
  create_ecs_role = true
  attach_with_role = ""
  codedeploy_role_name = ""
  pipeline_role_name = ""

}

#***************************iam policy****************************************#
module "policy_for_ecs_role" {
  source = "../Modules/IAM_Roles"
  name_ = "ecs-policy-${var.environment}"
  attach_with_role = module.role_for_ecs.ecs_name_
  codedeploy_role_name = ""
  ecs_task_role_name = ""
  pipeline_role_name = ""
  create_ecs_policy = true
}

#********************************task definition**********************************#
module "backend_ecs_task_definition" {
  source = "../Modules/ECS/TaskDefinition"
  containerPort = var.backend_port
  cpu = 256
  execution_role_arn = module.role_for_ecs.role_arn
  family = "ECS-FAMILY"
  hostPort = var.backend_port
  image = "nginx:latest"
  memory = "512"
  name = "backend-taskdef-${var.environment}"
  name_of_container = var.container_name_backend
  region = var.aws_region
  task_role_arn = module.role_for_ecs.ecs_task_role_arn
}
module "frontend_ecs_task_definition" {
  source = "../Modules/ECS/TaskDefinition"
  containerPort = var.frontend_port
  image = "nginx:latest"
  cpu = 256
  execution_role_arn = module.role_for_ecs.role_arn
  family = "ECS-FAMILY"
  hostPort = var.frontend_port
  memory = "512"
  name = "frontend-taskdef-${var.environment}"
  name_of_container = var.container_name_frontend
  region = var.aws_region
  task_role_arn = module.role_for_ecs.ecs_task_role_arn
}

#*******************security group for ecs tasks*****************************#
module "backend_ecs_security_group" {
  source = "../Modules/Security_Group"
  name = "backend-ecs-secgroup-${var.environment}"
  vpc_id = module.VPC.vpc_id
  security_group = [module.alb_backend_Security_group.security_group_id]
  ingress_port = var.backend_port
}
module "frontend_ecs_security_group" {
  source = "../Modules/Security_Group"
  name = "frontend-ecs-secgroup-${var.environment}"
  vpc_id = module.VPC.vpc_id
  security_group = [module.alb_frontend_Security_group.security_group_id]
  ingress_port = var.frontend_port
}

#*************ecs cluster**************************************************#
module "cluster_ecs" {
  source = "../Modules/ECS/Cluster"
  cluster_name = "${var.environment}-cluster"
}

#************************ecs services*************************************#
module "backend_ecs_service" {
  source = "../Modules/ECS/Service"
  cluster_id      = module.cluster_ecs.cluster_id
  container_name  = var.container_name_backend
  container_port  = var.backend_port
  desired_count   = 1
  name            = "${var.environment}-backend"
  security_groups = module.alb_backend_Security_group.security_group_id
  subnets = [module.VPC.private_subnet_backend_[0], module.VPC.private_subnet_backend_[1]]
  taskdef         = module.backend_ecs_task_definition.taskDef_arn
  depends_on = [module.App_load_balancer_server]

  alb_arn = module.server_target_group_blue.target_group_arn



}
module "frontend_ecs_service" {
  source = "../Modules/ECS/Service"
  cluster_id      = module.cluster_ecs.cluster_id
  container_name  = var.container_name_frontend
  container_port  = var.frontend_port
  desired_count   = 1
  name            = "${var.environment}-frontend"
  security_groups = module.alb_frontend_Security_group.security_group_id
  subnets = [module.VPC.private_subnet_frontend_[0], module.VPC.private_subnet_frontend_[1]]
  taskdef         = module.frontend_ecs_task_definition.taskDef_arn
  depends_on = [module.App_load_balancer_client]

  alb_arn         = module.target_group_client_blue.target_group_arn
}

#********************************Autoscaling policies for ecs *********************************************#
module "backend_autoscaling" {
  source = "../Modules/ECS/Autoscaling_Group"
  max_capacity    = 3
  min_capacity    = 1
  name            = "${var.environment}-backend"
  name_of_cluster = module.cluster_ecs.name_of_cluster
  depends_on = [module.backend_ecs_service]

}
module "frontend_autoscaling" {
  source = "../Modules/ECS/Autoscaling_Group"
  max_capacity = 3
  min_capacity = 1
  name = "${var.environment}-frontend"
  name_of_cluster = module.cluster_ecs.name_of_cluster
  depends_on = [module.frontend_ecs_service]
}