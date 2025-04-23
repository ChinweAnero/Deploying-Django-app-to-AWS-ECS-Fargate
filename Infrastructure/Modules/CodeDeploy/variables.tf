variable "name" {
  type = string
  description = "name of the resource"
}
variable "service_role_arn" {
  type = string
  description = "iam role arn"
}
variable "cluster_name" {
  type = string
  description = "cluster name"
}
variable "service_name" {
  type = string
  description = "service name"
}
variable "aws_lb_listener" {
  type = string
  description = "load balancer listener"
}
variable "blue_target_group" {
  type = string
  description = "blue target group"
}
variable "green_target_group" {
  type = string
  description = "blue target group"
}
variable "trigger_name" {
  type = string
  description = "trigger for deployment"
}
variable "sns_topic_arn" {
  type = string
  description = "sns topic arn"
}