variable "name" {
  type = string
  description = "The type of EC2 instance"
}
variable "hash_key" {
  type = string
  description = "hash key for the dynamodb"
  default = "id"
}
variable "range_key" {
  type = string
  description = "range for dynamodb"
  default = null
}
variable "attributes" {
  type = list(object({
    name = string
    type = string
  }))
  default = [{
    name = "id",
    type = "N"
  }]
  description = "attributes for the dynamodb"
}