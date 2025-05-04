variable "V_cidr_block" {
  type = string
  default = "10.0.0.0/16"
  description = "The type of EC2 instance"
}
variable "environment" {
  type = string
  description = "the name of the environment"
  validation {
    condition = length(var.environment) < 20
    error_message = "name must be less than 20 characters"
  }
  default = "prod"

}
variable "server_port" {
  type = number
  default = 3001
  description = "port used by the server"
}
variable "s3_bucket_name" {
  type = string
  description = "name of the s3 bucket"
  default = ""
}
variable "iam_role_name" {
  type = string
  description = "name of iam role"
  default = "App"
}
variable "hash_k" {
  type = string
  default = "id"
}
variable "range" {
  type = string
  default = ""
}
variable "aws_region" {
  type = string
  description = "aws region"
  default = "eu-west-2"

}
variable "container_name_backend" {
  type = string
  default = "Backend-container"
}
variable "container_name_frontend" {
  type = string
  default = "frontend-container"
}
variable "backend_port" {
  type = number
  default = 3001
  description = "backend port"
}
variable "frontend_port" {
  type = number
  default = 80
  description = "frontend-port"
}
variable "iam_for_cicd" {
  type = map(string)
  default = {
    pipeline = "pipeline_role"
    ecs = "ecs_task_exec_role"
    ecs_task_role = "ecs_task_role"
    codedeploy_role = "CodeDeploy_role"
  }
}
variable "build_spec" {
  type = string
  default     = "./Infrastructure/Templates/buildspec.yml"
  description = "build path"
}
variable "folder_path_backend" {
  type = string
  default = "./Code/backend"
  description = "where application frontend files are stored"
}
variable "folder_path_frontend" {
  type = string
  default = "./Code/frontend"
  description = "where application frontend files are stored"
}
variable "trigger_name" {
  type = string
  default = "Trigger-group-eu-west2-instances-start"
  description = "code deploy trigger name"
}

variable "Repository" {
  type = string
  description = "repo name"
  default = "https://github.com/ChinweAnero/Deploy_App_in_AWS"
}

variable "repo_branch" {
  type = string
  description = "branch for pipeline to use"
  default = "main"
}

variable "codestar_github_name" {
  type = string
  description = "name of the codestar resource"
  default = "connect_github"
}

