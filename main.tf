

# The configuration for the `remote` backend.
terraform {
  backend "remote" {

    organization = "Chinwe-Org"


    workspaces {
      name = "weather_app_infra_workspace"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.3"
    }
  }
}


# AWS Provider
provider "aws" {
  region                   = "eu-west-2"

}

#*******************Network*****************************
module "VPC" {
  source = "./Infrastructure/Modules/Network"
  vpc_cidr_block = var.V_cidr_block
  vpc_name = var.environment
}

module "alb_frontend_Security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  vpc_id         = module.VPC.vpc_id
  ingress_cidr_block = ["0.0.0.0/0"]
  ingress_port = 8000
  name = "alb-${var.environment}-frontend"


}

module "alb_frontend_sec_group_rule" {
  source = "./Infrastructure/Modules/Security Group Rules"
  security_group_id = module.alb_frontend_Security_group.security_group_id
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  type = "ingress"
}

module "prometheus_security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  vpc_id = module.VPC.vpc_id
  ingress_cidr_block = ["0.0.0.0/0"]
  ingress_port = 8000
  name = "promethues-sec_group${var.environment}"

}
module "prometheus_security_group-rule" {
  source = "./Infrastructure/Modules/Security Group Rules"
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "tcp"
  from_port = 80
  to_port = 80
  security_group_id = module.prometheus_security_group.security_group_id
  type = "ingress"
}

module "prometheusUI_security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  vpc_id = module.VPC.vpc_id
  ingress_cidr_block = ["0.0.0.0/0"]
  ingress_port = 9090
  name = "promethuesui-sec_group${var.environment}"
}
module "prometheusUI_security_group-rule" {
  source = "./Infrastructure/Modules/Security Group Rules"
  cidr_blocks = ["0.0.0.0/0"]
  protocol = "tcp"
  from_port = 80
  to_port = 80
  security_group_id = module.prometheusUI_security_group.security_group_id
  type = "ingress"
}



module "alb_backend_Security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  vpc_id         = module.VPC.vpc_id
  ingress_cidr_block = ["0.0.0.0/0"]
  ingress_port = 8000
  name = "alb-${var.environment}-backend"
}

#*********************configuring target groups for server environments********************************#
module "server_target_group_blue" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name = "targetg-${var.environment}-server-blue"
  vpc_id = module.VPC.vpc_id
  target_type = "ip"
  port = 8000
  protocol = "HTTP"
  healthcheck_path = "/health/"
  healthcheck_port = var.server_port
  create_target_group = true

}

module "server_target_group_green" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name = "targetg-${var.environment}-server-green"
  vpc_id = module.VPC.vpc_id
  target_type = "ip"
  port = 8000
  protocol = "HTTP"
  healthcheck_path = "/health/"
  healthcheck_port = var.server_port
  create_target_group = true

}
#*******************************target group for client environments**********************#
module "target_group_client_blue" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "targetg-${var.environment}-client-blue"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 8000
  protocol = "HTTP"
  target_type = "ip"
  healthcheck_path = "/health/"
  healthcheck_port = var.server_port
}
module "target_group_client_green" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "targetg-${var.environment}-client-green"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 8000
  protocol = "HTTP"
  target_type = "ip"
  healthcheck_path = "/health/"
  healthcheck_port = var.server_port
}


 # import {
 #   to = module.prometheus_target_group_blue.aws_lb_target_group.ip_target_group[0]
 #   id = module.prometheus_target_group_blue.aws_lb_target_group.arn
 # }
module "prometheus_target_group_blue" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "prometheus-${var.environment}-target-group-b"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 8080
  target_type = "ip"
  protocol = "HTTP"
  healthcheck_path = "/-/healthy"
  healthcheck_port = var.server_port

}

# import {
#    to = module.prometheus_target_group_green.aws_lb_target_group.ip_target_group[0]
#    id = module.prometheus_target_group_green.aws_lb_target_group.arn
#  }
module "prometheus_target_group_green" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "prometheus-${var.environment}-target-group-g"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 8080
  target_type = "ip"
  protocol = "HTTP"
  healthcheck_path = "/-/healthy"
  healthcheck_port = var.server_port

}

module "prometheus_ui_target_group" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "prometheus-${var.environment}-UI"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 9090
  target_type = "ip"
  protocol = "HTTP"
  healthcheck_path = "/"
  healthcheck_port = var.server_port

}

module "prometheus_ui_target_group_g" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "prometheus-${var.environment}-UI-g"
  vpc_id = module.VPC.vpc_id
  create_target_group = true
  port = 9090
  target_type = "ip"
  protocol = "HTTP"
  healthcheck_path = "/"
  healthcheck_port = var.server_port

}

#****************************configuring load balancer for both client and server**************************#
module "App_load_balancer_server" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name = "App-lb-${var.environment}-backend"
  create_load_balancer = true
  subnets = [module.VPC.public_subnets[0], module.VPC.public_subnets[1]]
  sec_group = module.alb_backend_Security_group.security_group_id
  target_group_arn = module.server_target_group_blue.target_group_arn

  vpc_id = module.VPC.vpc_id
}

module "App_load_balancer_client" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name = "App-lb-${var.environment}-frontend"
  create_load_balancer = true
  subnets = [module.VPC.public_subnets[0], module.VPC.public_subnets[1]]
  sec_group = module.alb_frontend_Security_group.security_group_id
  target_group_arn = module.target_group_client_blue.target_group_arn

  vpc_id = module.VPC.vpc_id

}

module "prometheus_loadbalancer-b" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "Promethues-lb${var.environment}-b"
  vpc_id = module.VPC.vpc_id
  create_load_balancer = true
  subnets = [module.VPC.public_subnets[0], module.VPC.public_subnets[1]]
  sec_group = module.prometheus_security_group.security_group_id
  target_group_arn = module.prometheus_target_group_blue.target_group_arn

}
module "prometheusUI_loadbalancer" {
  source = "./Infrastructure/Modules/LoadBalancer"
  name   = "Promethues-UI-lb${var.environment}"
  vpc_id = module.VPC.vpc_id
  create_load_balancer = true
  subnets = [module.VPC.public_subnets[0], module.VPC.public_subnets[1]]
  sec_group = module.prometheusUI_security_group.security_group_id
  target_group_arn = module.prometheus_ui_target_group.target_group_arn

}


#****************creating the s3 bucket**********************************#
module "s3" {
  source = "./Infrastructure/Modules/S3"
  bucket_name = var.s3_bucket_name
}
#********************ecr for frontend and backend docker images*************#
module "frontend_ecr" {
  source = "./Infrastructure/Modules/ECR"
  erc_name = "frontend-ecr-repo"
}
module "backend_ecr" {
  source = "./Infrastructure/Modules/ECR"
  erc_name = "backend-ecr-repo"
}

module "promethues_repo" {
  source = "./Infrastructure/Modules/ECR"
  erc_name = "prometheus-monitoring"
}
#*******************************dynamodb**************************************#
module "dynamodb_table" {
  source = "./Infrastructure/Modules/DynamoDB"
  name = "Artifacts_table-${var.environment}"

  hash_key  = var.hash_k
  range_key = var.range

}

#*********************creating ecs role***************************************#
module "role_for_ecs" {
  source = "./Infrastructure/Modules/IAM_Roles"
  dynamo_db = [module.dynamodb_table.dynamodb_arn]
  ecs_task_role_name = "ecs-task-${var.iam_role_name}"
  name_ = "ecs-name-${var.iam_role_name}"
  create_ecs_role = true
  attach_with_role = ""
  codedeploy_role_name = ""
  pipeline_role_name = ""

}

#***************************iam policy for ecs****************************************#
module "policy_for_ecs_role" {
  source = "./Infrastructure/Modules/IAM_Roles"
  name_ = "ecs-policy-${var.environment}"
  attach_with_role = module.role_for_ecs.ecs_name_
  codedeploy_role_name = ""
  ecs_task_role_name = module.role_for_ecs.ecs_task_role_name
  pipeline_role_name = ""
  create_ecs_policy = true
}

#********************************task definition**********************************#
module "backend_ecs_task_definition" {
  source = "./Infrastructure/Modules/ECS/TaskDefinition"
  containerPort = var.backend_port
  cpu = 256
  execution_role_arn = module.role_for_ecs.role_arn
  family = "ECS-FAMILY"
  hostPort = var.backend_port
  image = "python:3.12-slim"
  memory = "512"
  name = "backend-taskdef-${var.environment}"
  name_of_container = var.container_name_backend
  region = var.aws_region
  task_role_arn = module.role_for_ecs.ecs_task_role_arn

  clusterName = module.cluster_ecs.name_of_cluster


}
module "frontend_ecs_task_definition" {
  source = "./Infrastructure/Modules/ECS/TaskDefinition"
  containerPort = var.frontend_port
  image = "python:3.12-slim"
  cpu = 256
  execution_role_arn = module.role_for_ecs.role_arn
  family = "ECS-FAMILY"
  hostPort = var.frontend_port
  memory = "512"
  name = "frontend-taskdef-${var.environment}"
  name_of_container = var.container_name_frontend
  region = var.aws_region
  task_role_arn = module.role_for_ecs.ecs_task_role_arn

  clusterName  = module.cluster_ecs.name_of_cluster

}
module "prometheusUI_TASK_definition" {
  source = "./Infrastructure/Modules/ECS/PromTask Definition"
  containerPort = 9090
  image = "python:3.12-slim"
  cpu = 256
  execution_role_arn = module.role_for_ecs.role_arn
  family = "ECS-FAMILY"
  hostPort = 9090
  memory = "512"
  name = "frontend-taskdef-${var.environment}"
  name_of_container = var.prometheus_container
  region = var.aws_region
  task_role_arn = module.role_for_ecs.ecs_task_role_arn

  clusterName  = module.cluster_ecs.name_of_cluster

}

#*******************security group for ecs tasks*****************************#
module "backend_ecs_security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  name = "backend-ecs-secgroup-${var.environment}"
  vpc_id = module.VPC.vpc_id
  security_group = [module.alb_backend_Security_group.security_group_id]
  ingress_port = var.backend_port
}
module "frontend_ecs_security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  name = "frontend-ecs-secgroup-${var.environment}"
  vpc_id = module.VPC.vpc_id
  security_group = [module.alb_frontend_Security_group.security_group_id]
  ingress_port = var.frontend_port

}
module "promethues_ecs_security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  name = "promethues-ecs-security_group${var.environment}"
  vpc_id = module.VPC.vpc_id
  security_group = [module.prometheus_security_group.security_group_id]
  ingress_port = 8000
}

module "prometheusUI_ecs_security_group" {
  source = "./Infrastructure/Modules/Security_Group"
  vpc_id = module.VPC.vpc_id
  security_group = [module.prometheusUI_security_group.security_group_id]
  ingress_port = 9090
}

#*************ecs cluster**************************************************#
module "cluster_ecs" {
  source = "./Infrastructure/Modules/ECS/Cluster"
  cluster_name = "${var.environment}-cluster"
}

#************************ecs services*************************************#
module "backend_ecs_service" {
  source = "./Infrastructure/Modules/ECS/Service"
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
  source = "./Infrastructure/Modules/ECS/Service"
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

module "prometheus_ecs_service" {
  source = "./Infrastructure/Modules/ECS/Service"
  alb_arn = module.prometheus_target_group_blue.target_group_arn
  cluster_id = module.cluster_ecs.cluster_id
  container_name = "prometheus"
  container_port = 8080
  desired_count = 1
  name = "promethues-ecs${var.environment}"
  security_groups = module.prometheus_security_group.security_group_id
  subnets = [module.VPC.private_subnet_frontend_[0], module.VPC.private_subnet_frontend_[1]]
  taskdef = module.frontend_ecs_task_definition.taskDef_arn
  depends_on = [module.prometheus_loadbalancer-b.load_balancer_arn]

}

module "prometheus_UI-ecs_service" {
  source = "./Infrastructure/Modules/ECS/Service"
  alb_arn = module.prometheus_ui_target_group.target_group_arn
  cluster_id = module.cluster_ecs.cluster_id
  container_name = "prometheus"
  container_port = 8080
  desired_count = 1
  name = "promethues-UI-ecs${var.environment}"
  security_groups = module.prometheusUI_security_group.security_group_id
  subnets = [module.VPC.private_subnet_frontend_[0], module.VPC.private_subnet_frontend_[1]]
  taskdef = module.prometheusUI_TASK_definition.taskDef_arn
  depends_on = [module.prometheusUI_loadbalancer.load_balancer_arn]

}

#********************************Autoscaling policies for ecs *********************************************#
module "backend_autoscaling" {
  source = "./Infrastructure/Modules/ECS/Autoscaling_Group"
  max_capacity    = 3
  min_capacity    = 1
  name            = "${var.environment}-backend"
  name_of_cluster = module.cluster_ecs.name_of_cluster
  depends_on = [module.backend_ecs_service]

}
module "frontend_autoscaling" {
  source = "./Infrastructure/Modules/ECS/Autoscaling_Group"
  max_capacity = 3
  min_capacity = 1
  name = "${var.environment}-frontend"
  name_of_cluster = module.cluster_ecs.name_of_cluster
  depends_on = [module.frontend_ecs_service]
}

#************************configuring ci/cd pipeline*********************************************************#
### s3 bucket for codepipeline###
resource "random_id" "random" {
  byte_length = 8
}
module "s3_codepipeline" {
  source = "./Infrastructure/Modules/S3"
  bucket_name = "bucket-for-codepipeline-${random_id.random.hex}"
}

#### IAM role for codepipeline######
module "pipeline_role" {
  source = "./Infrastructure/Modules/IAM_Roles"
  name_ = var.iam_for_cicd["pipeline"]
  create_pipeline_role = true

  attach_with_role     = ""
  codedeploy_role_name = ""
  ecs_task_role_name   = ""
  pipeline_role_name   = var.iam_for_cicd["pipeline"]
}

module "codedeploy_iam_role" {
  source = "./Infrastructure/Modules/IAM_Roles"
  create_role_for_codedeploy = true
  name_ = var.iam_for_cicd["codedeploy_role"]
  attach_with_role = ""
  codedeploy_role_name = var.iam_for_cicd["codedeploy_role"]
  ecs_task_role_name = ""
  pipeline_role_name = var.iam_for_cicd["codedeploy_role"]

}

## iam role policy#####
module "policy_for_pipeline_role" {
  source = "./Infrastructure/Modules/IAM_Roles"
  name_ = "pipeline-${var.environment}"
  create_pipeline_policy = true
  attach_with_role = module.pipeline_role.ecs_name_
  create_ecs_policy = true
  ecr_repo = [module.backend_ecr.ecr_repo_arn, module.frontend_ecr.ecr_repo_arn,   module.promethues_repo.ecr_repo_arn]
  codebuild_projects = [module.codebuild_backend.project_arn, module.codebuild_frontend.project_arn, module.codebuild_prometheus.project_arn, module.codebuild_prometheusUI.project_arn]
  code_deploy_projects = [module.codedeploy_backend.application_arn, module.codedeploy_backend.deployment_group_arn, module.codedeploy_frontend.application_arn, module.codedeploy_frontend.deployment_group_arn, module.prometheus_codedeploy.deployment_group_arn, module.prometheusUI_codedeploy.deployment_group_arn]
  codedeploy_role_name = ""
  ecs_task_role_name = ""
  pipeline_role_name = ""
}

## aws caller identity###
data "aws_caller_identity" "current" {}
output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

## Codebuild projects#####
module "codebuild_backend" {
  source = "./Infrastructure/Modules/CodeBuild"
  aws_account_id         = data.aws_caller_identity.current.account_id
  backend_lb_url         = ""
  build_spec             = var.build_spec
  container_name         = var.container_name_backend
  dynamodb_table         = module.dynamodb_table.dynamodb_name
  ecs_role               = var.iam_for_cicd["ecs"]
  ecs_task_role          = var.iam_for_cicd["ecs_task_role"]
  folder_path            = var.folder_path_backend
  name                   = "codebuild-backend-${var.environment}"
  region_aws             = var.aws_region
  repo_url               = module.backend_ecr.ecr_repo_url
  service_port           = var.backend_port
  service_role_arn       = module.pipeline_role.role_arn
  task_definition_family = module.backend_ecs_task_definition.taskDef_family

}
module "codebuild_frontend" {
  source = "./Infrastructure/Modules/CodeBuild"
  aws_account_id = data.aws_caller_identity.current.account_id
  backend_lb_url = module.App_load_balancer_server.load_balancer_dns
  build_spec = var.build_spec
  container_name = var.container_name_frontend
  dynamodb_table = ""
  ecs_role = var.iam_for_cicd["ecs"]
  ecs_task_role = module.role_for_ecs.ecs_task_role_name
  folder_path = var.folder_path_frontend
  name = "codebuild-frontend-${var.environment}"
  region_aws = var.aws_region
  repo_url = module.frontend_ecr.ecr_repo_url
  service_port = var.frontend_port
  service_role_arn = module.pipeline_role.role_arn
  task_definition_family = module.frontend_ecs_task_definition.taskDef_family

}

module "codebuild_prometheus" {
  source = "./Infrastructure/Modules/CodeBuild"
  aws_account_id = data.aws_caller_identity.current.account_id
  backend_lb_url = module.prometheus_loadbalancer-b.load_balancer_dns
  build_spec = var.build_spec
  container_name = var.prometheus_container
  dynamodb_table = ""
  ecs_role = var.iam_for_cicd["ecs"]
  ecs_task_role = module.role_for_ecs.ecs_task_role_name
  folder_path = var.prometheus_folder_path
  name = "codebuild-prometheus-${var.environment}"
  region_aws = var.aws_region
  repo_url = module.promethues_repo.ecr_repo_url
  service_port = 8080
  service_role_arn = module.pipeline_role.role_arn
  task_definition_family = module.frontend_ecs_task_definition.taskDef_family
}
module "codebuild_prometheusUI" {
  source = "./Infrastructure/Modules/CodeBuild"
  aws_account_id = data.aws_caller_identity.current.account_id
  backend_lb_url = module.prometheusUI_loadbalancer.load_balancer_dns
  build_spec = var.build_spec
  container_name = var.prometheus_container
  dynamodb_table = ""
  ecs_role = var.iam_for_cicd["ecs"]
  ecs_task_role = module.role_for_ecs.ecs_task_role_name
  folder_path = var.prometheus_folder_path
  name = "codebuild-prometheusUI-${var.environment}"
  region_aws = var.aws_region
  repo_url = module.promethues_repo.ecr_repo_url
  service_port = 8080
  service_role_arn = module.pipeline_role.role_arn
  task_definition_family = module.prometheusUI_TASK_definition.taskDef_family
}


## codedeploy projects###
module "codedeploy_backend" {
  source = "./Infrastructure/Modules/CodeDeploy"
  aws_lb_listener    = module.App_load_balancer_server.listener_arn
  blue_target_group  = module.server_target_group_blue.target_group_name
  cluster_name       = module.cluster_ecs.name_of_cluster
  green_target_group = module.server_target_group_green.target_group_name
  name               = "sever-codedeploy-${var.environment}"
  service_name       = module.backend_ecs_service.ecs_name
  service_role_arn   = module.codedeploy_iam_role.codedeploy_arn
  sns_topic_arn      = module.sns_topic.sns_arn
  trigger_name       = var.trigger_name
}
module "codedeploy_frontend" {
  source = "./Infrastructure/Modules/CodeDeploy"
  aws_lb_listener = module.App_load_balancer_client.listener_arn
  blue_target_group = module.target_group_client_blue.target_group_name
  cluster_name = module.cluster_ecs.name_of_cluster
  green_target_group = module.target_group_client_green.target_group_name
  name = "client-codedeploy-${var.environment}"
  service_name = module.frontend_ecs_service.ecs_name
  service_role_arn = module.codedeploy_iam_role.codedeploy_arn
  sns_topic_arn = module.sns_topic.sns_arn
  trigger_name = var.trigger_name
}
module "prometheus_codedeploy" {
  source = "./Infrastructure/Modules/CodeDeploy"
  aws_lb_listener    = module.prometheus_loadbalancer-b.listener_arn
  blue_target_group  = module.prometheus_target_group_blue.target_group_name
  cluster_name       = module.cluster_ecs.name_of_cluster
  green_target_group = module.prometheus_target_group_green.target_group_name
  name               = "prom-codedeploy-${var.environment}"
  service_name       = module.prometheus_ecs_service.ecs_name
  service_role_arn   = module.codedeploy_iam_role.codedeploy_arn
  sns_topic_arn      = module.sns_topic.sns_arn
  trigger_name       = var.trigger_name
}

module "prometheusUI_codedeploy" {
  source = "./Infrastructure/Modules/CodeDeploy"
  aws_lb_listener    = module.prometheusUI_loadbalancer.listener_arn
  blue_target_group  = module.prometheus_ui_target_group.target_group_name
  cluster_name       = module.cluster_ecs.name_of_cluster
  green_target_group = module.prometheus_ui_target_group_g.target_group_name
  name               = "promUI-codedeploy-${var.environment}"
  service_name       = module.prometheus_UI-ecs_service.ecs_name
  service_role_arn   = module.codedeploy_iam_role.codedeploy_arn
  sns_topic_arn      = module.sns_topic.sns_arn
  trigger_name       = var.trigger_name
}




#**************sns topic**********************#
module "sns_topic" {
  source = "./Infrastructure/Modules/SNS"
  name_sns = "notifications-${var.environment}"
}

### s3 for backend assets#####
module "s3_for_backend" {
  source = "./Infrastructure/Modules/S3"
  bucket_name = "bucket-for-backend-${random_id.random.hex}"
}
#***********connection to github**************#
module "codestar_connection_to_github" {
source = "./Infrastructure/Modules/CodeStar_Connection"
codestar_name = var.codestar_github_name
}

#****************codepipeline
module "codepipeline" {
  source = "./Infrastructure/Modules/CodePipline"
  AppName_Backend = module.codedeploy_backend.app_name
  AppName_frontend = module.codedeploy_frontend.app_name
  Branch = var.repo_branch
  DeploymentGroup_backend = module.codedeploy_backend.deployment_group_name
  DeploymentGroup_frontend = module.codedeploy_frontend.deployment_group_name
  #Owner = var.Owner
  ProjectName_backend = module.codebuild_backend.project_id
  ProjectName_frontend = module.codebuild_frontend.project_id
  Repository = var.Repository
  code_pipeline_role_arn = module.pipeline_role.role_arn
  name = "pipeline-${var.environment}"
  s3_bucket_for_codepipelineartifacts = module.s3_for_backend.bucket_id
  depends_on = [module.policy_for_pipeline_role]
  connection_arn     = module.codestar_connection_to_github.codestar_arn
  PromprojectName = module.codebuild_prometheus.project_id
  PromappName = module.prometheus_codedeploy.app_name
  PromDeploymentGroup = module.prometheus_codedeploy.deployment_group_name
  PromUIDeploymentGroup = module.prometheusUI_codedeploy.deployment_group_name
  PromUIappName = module.prometheusUI_codedeploy.app_name
  PromuiprojectName = module.codebuild_prometheusUI.project_id
}
# import {
#   id = ""
#   to = module.prometheus_log_group.aws_cloudwatch_log_group.prometheus_log_group
# }
module "prometheus_log_group" {
  source = "./Infrastructure/Modules/Prometheus-CW_log"
  log_group_name = "/ecs/prometheus"
}

module "parameter_store" {
  source = "./Infrastructure/Modules/Parameter Store"
  clusterName = module.cluster_ecs.name_of_cluster
  name = "parameter_store"
  type = "SecureString"
}

###########exposing port 8000 listerner for prometheus
module "prometheus_port_listener" {
  source = "./Infrastructure/Modules/Prometheus Listener"
  prometheus-loadbalancer = module.prometheus_loadbalancer-b.load_balancer_arn
  prometheus-target-group-arn = module.prometheus_target_group_blue.target_group_arn


}
module "prometheus_listener_rule" {
  source = "./Infrastructure/Modules/Prometheus LoadBalancer"
  listener_arn = module.prometheus_port_listener.prometheus_listener_arn
  prometheus-target-group-arn = module.prometheus_target_group_blue.target_group_arn

}

###########exposing prometheus ui on port 9090#############
module "prometheuis_ui_listener" {
  source = "./Infrastructure/Modules/PrometheusUI Listener"
  prometheus-loadbalancer = module.prometheusUI_loadbalancer.load_balancer_arn
  prometheus-target-group-arn = module.prometheus_ui_target_group.target_group_arn
}
module "prometheus_ui_listener_rule" {
  source = "./Infrastructure/Modules/PrometheusUI Loadbalancer"
  listener_arn = module.prometheuis_ui_listener.prometheus_listener_arn
  prometheus-target-group-arn = module.prometheus_ui_target_group.target_group_arn
}
