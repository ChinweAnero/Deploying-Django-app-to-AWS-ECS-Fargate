variable "name" {
  type = string
  description = "name of the resource"
}
variable "service_role_arn" {
  type = string
  description = "arn of the iam role"
}
variable "region_aws" {
  type = string
  description = "aws region"
}
variable "aws_account_id" {
  type = string
  description = "account id"
}
variable "repo_url" {
  type = string
  description = "ecr repo url"
}
variable "dynamodb_table" {
  type = string
  description = "dynamo db table used for storing artifacts"
}
variable "task_definition_family" {
  type = string
  description = "task definition family"
}
variable "container_name" {
  type = string
  description = "name of container"
}
variable "service_port" {
  type = string
  description = "service port"
}
variable "folder_path" {
  type = string
  description = "path to folder"
}
variable "ecs_role" {
  type = string
  description = "iam role for ecs"
}
variable "ecs_task_role" {
  type = string
  description = "ecs task role"
}
variable "backend_lb_url" {
  type = string
  description = "load-balancer url"
}
variable "build_spec" {
  type = string
  description = "build spec path"
}