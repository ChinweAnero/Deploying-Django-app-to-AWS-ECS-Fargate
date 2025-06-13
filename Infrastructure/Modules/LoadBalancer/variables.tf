variable "name" {
  type = string
  description = "name of the app load balancer/target group"

}
variable "sec_group" {
  type = string
  description = "the security group for the load balancer"
  default = ""
}
variable "subnets" {
  type = list(any)
  default = []

}
variable "create_load_balancer" {
  type = bool
  default = false
  description = "determines weather or not to create load balancer"
}
variable "target_group_arn" {
  type = string
  description = "the arn of the target group"
  default = ""
}
variable "enable_https_listener" {
  type = bool
  description = "weather or not to create https listener"
  default = false
}
# variable "target-group-name" {
#   type = string
#   description = "name of the target group"
#   default = ""
#
# }
variable "port" {
  type = number
  description = "the http port number"
  default = 8000
}
variable "protocol" {
  type = string
  description = "the protocol to use"
  default = ""
}
variable "target_type" {
  type = string
  description = "the target group type"
  default = ""
}
variable "vpc_id" {
  type = string
  description = "the id of the vpc"
}
variable "healthcheck_path" {
  type = string
  default = ""
  description = "the path of the health check"
}
variable "healthcheck_port" {
  type = string
  description = "health check port"
  default = 8000
}
variable "create_target_group" {
  type = bool
  default = false
  description = "determines if a target group needs to be created"
}
# variable "target_group_green" {
#   type = string
#   default = ""
#   description = "the arn for the target group"
# }
variable "listener_arn" {
  type = string
}