
# variable "ecs_exec_role_name" {
#   type = string
#   description = "name of the ecs task"
#   default = null
# }
variable "create_ecs_role" {
  type = bool
  default = false
  description = "determines if role is created or not?"
}
variable "ecs_task_role_name" {
  type = string
  description = "nme of the ecs task role"
}
variable "create_pipeline_role" {
  type = bool
  default = false
  description = "determines if role is created or not?"
}
variable "pipeline_role_name" {
  type = string
  description = "name of the pipeline role"

}
variable "create_role_for_codedeploy" {
  type = bool
  default = false
  description = "determines if role is created"
}
variable "codedeploy_role_name" {
  type = string
  description = "name of codedeploy role"
}
variable "create_pipeline_policy" {
  type = bool
  description = "determines if to create policy or not"
  default = false
}

variable "name_" {
  type = string
  description = "role name"
}

variable "codebuild_projects" {
  type = list(string)
  description = "codebuild projects"
  default = ["*"]
}
variable "code_deploy_projects" {
  type = list(string)
  description = "codedeploy projects"
  default = ["*"]
}
variable "ecr_repo" {
  type = list(string)
  description = "ecr_repo"
  default = ["*"]
}
variable "s3_assets" {
  type = list(string)
  description = "s3 for storing ecs assets"
  default = ["*"]

}
variable "dynamo_db" {
  type = list(string)
  description = "dynamodb table for strong artifacts"
  default = ["*"]
}
variable "attach_with_role" {
  type = string
  description = "policy arn"
}
variable "create_ecs_policy" {
  type = bool
  default = false
  description = "determines if policy is created"
}