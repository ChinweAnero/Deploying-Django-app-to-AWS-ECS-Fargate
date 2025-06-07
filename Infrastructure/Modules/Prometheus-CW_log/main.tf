resource "aws_cloudwatch_log_group" "prometheus_log_group" {
  name = var.log_group_name

  tags = {
    Environment = "production"
    Application = "Prometheus-monitoring"
  }
}