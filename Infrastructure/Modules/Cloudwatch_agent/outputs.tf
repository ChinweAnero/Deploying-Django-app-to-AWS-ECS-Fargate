output "parameter_store_value" {
  value = aws_ssm_parameter.cloudwatch_agent.value
}
output "parameter_store_id" {
  value = aws_ssm_parameter.cloudwatch_agent.id
}
output "parameter_store_name" {
  value = aws_ssm_parameter.cloudwatch_agent.name
}

