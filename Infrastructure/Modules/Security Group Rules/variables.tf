variable "from_port" {
  type = number
  default = 0

}
variable "to_port" {
  type = number
  default = 0

}
variable "security_group_id" {
  type = string
  description = "security group to assign the rule to"

}
variable "protocol" {
  type = string
  description = "the protocol for the rule"
}
variable "cidr_blocks" {
  type = list(string)
}
variable "type" {
  type = string
}

