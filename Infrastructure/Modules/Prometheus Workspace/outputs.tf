output "workspace_id" {
  value = aws_prometheus_workspace.prometheus_metrics_logging.id
  description = "prometheus workspace id"
}