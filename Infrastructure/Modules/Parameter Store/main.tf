resource "aws_ssm_parameter" "parameters" {
  name = var.name
  type = var.type
  value = "bar"

  }






