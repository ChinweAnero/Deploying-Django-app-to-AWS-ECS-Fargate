variable "vpc_id" {
  type = string
  description = "ID of the vpc"
}

variable "ingress_port" {
  type = number
  default = 0

}

variable "egress_port" {
  type = number
  default = 0
}

variable "ingress_cidr_block" {
  default = null
  type = list(any)
  description = "cidr block for inward traffic"
}
variable "egress_cidr_block" {
  default = ["0.0.0.0/0"]
  type = list(any)
  description = "cidr block for outward traffic"
}
variable "security_group" {
  type = list(any)
  description = "the security groups to associate to instances"
  default = null
}

