variable "name" {
  type = string
  description = "name of resource"
}
variable "cluster_id" {
  type = string
  description = "id of the cluster"
}
variable "alb_arn" {
  type = string
  description = "the load balancer arn"
}
variable "taskdef" {
  type = string
  description = "task definition to use"
}
variable "desired_count" {
  type = string
  description = "ecs fargate desired count"
}
variable "subnets" {
  type = list(string)
  description = "subnets to configure networking with"
}
variable "security_groups" {
  type = string
  description = "security group to configure networking with"
}
variable "container_name" {
  type = string
  description = "name of the container to use"
}
variable "container_port" {
  type = string
  description = "port to open"
}

