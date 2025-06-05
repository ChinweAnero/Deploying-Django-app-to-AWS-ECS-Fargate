variable "family" {
  type = string
  description = "task definition family"
}
variable "cpu" {
  type = string
  description = "cpu variable of te service"
}
variable "memory" {
  type = string
  description = "memory variable of the service"
}
variable "execution_role_arn" {
  type = string
  description = "execution role arn"
}
variable "task_role_arn" {
  type = string
  description = "task role for the service"
}
variable "name" {
  type = string
  description = "name of the resource"
}
variable "region" {
  type = string
  description = "region for the cloudwatch log"
}
variable "image" {
  type = string
  description = "docker image to use"
}
variable "name_of_container" {
  type = string
  description = "container name to use"

}
variable "containerPort" {
  type = number
  description = "container port"
}
variable "hostPort" {
  type = number
  description = "hostport"

}
variable "aws_ssm_parameter_value" {
  type = string
}
variable "aws_cloudwatch_agent_log_group_name" {
  type = string
}
variable "clusterName" {
  type = string
}

