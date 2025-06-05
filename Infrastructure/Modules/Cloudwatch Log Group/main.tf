resource "aws_cloudwatch_log_group" "cwagent_logs" {
  name = var.cloudwatch_log_group_name
  retention_in_days = 30

  tags = {
    Environment = "production"
    Application = "Django_App"
  }
}