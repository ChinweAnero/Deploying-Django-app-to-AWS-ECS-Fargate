resource "aws_prometheus_workspace" "prometheus_metrics_logging" {
  alias = var.prometheus_workspace

  tags = {
    Environment = "production"
  }
}