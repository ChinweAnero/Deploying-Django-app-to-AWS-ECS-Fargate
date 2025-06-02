
variable "region" {
  type = string
  default = "eu-west-2"
}
variable "cloudwatch_agent_name" {
  type = string

}
variable "cloudwatch_agent_type" {
  type = string

}
variable "clusterName" {
  type = string
}

variable "promethues_workspace_id" {
  type = string
  description = "promethues workspace"
}