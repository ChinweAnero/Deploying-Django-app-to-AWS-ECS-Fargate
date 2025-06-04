resource "aws_ssm_parameter" "cloudwatch_agent" {
  name = var.cloudwatch_agent_name
  type = var.cloudwatch_agent_type

  value = jsonencode({
    metrics = {
      metrics_collected = {
        prometheus = {
          prometheus_config_path = "/opt/aws/amazon-cloudwatch-agent/etc/prometheus.yml"
        }
      }

      metrics_destinations = {
        amp = {
          region       = "eu-west-2"
          workspace_id = var.promethues_workspace_id
        }
      }

      append_dimensions = {
        ClusterName = var.clusterName
      }

    }
  })
  }






