resource "aws_ssm_parameter" "cloudwatch_agent" {
  name  = var.cloudwatch_agent_name
  type  = var.cloudwatch_agent_type

  value =  jsonencode({
    agent = {
      region = var.region
      metrics_collection_interval = 60
    },
    metrics = {
      metrics_collected = {
        prometheus = {
          prometheus_config_path = "/opt/aws/amazon-cloudwatch-agent/etc/prometheus.yml",

        }
      }
    }
  })
}

