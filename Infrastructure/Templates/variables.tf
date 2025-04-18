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