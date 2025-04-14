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