output "cloudwatch_agent_log_group_name" {
  value = aws_cloudwatch_log_group.cwagent_logs.name
}