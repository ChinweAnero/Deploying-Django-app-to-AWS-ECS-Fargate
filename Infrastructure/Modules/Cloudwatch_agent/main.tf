resource "aws_ssm_parameter" "cloudwatch_agent" {
  name  = var.cloudwatch_agent_name
  type  = var.cloudwatch_agent_type

  value =  jsonencode({
    agent = {
      region = var.region
    },
    metrics = {
      metrics_collected = {
        prometheus = {
          prometheus_config_path = "prometheus.yml",
          emf_processor = {
            metric_namespace = "DjangoAppPrometheus"
          }
        }
      }
    }
  })
}

