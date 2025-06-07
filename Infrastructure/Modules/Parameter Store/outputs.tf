output "parameter_store_value" {
  value = aws_ssm_parameter.parameters.value
}
output "parameter_store_id" {
  value = aws_ssm_parameter.parameters.id
}
output "parameter_store_name" {
  value = aws_ssm_parameter.parameters.name
}

