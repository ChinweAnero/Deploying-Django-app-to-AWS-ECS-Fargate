variable "max_capacity" {
  type = number
  description = "autoscaling maximum capacity"
}
variable "min_capacity" {
  type = number
  description = "autoscaling minimum capacity"
}
variable "name" {
  type = string
  description = "name of the resource"
}
variable "name_of_cluster" {
  type = string
  description = "name of the cluster"
}