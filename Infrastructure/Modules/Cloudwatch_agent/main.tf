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

    },
    otel = {
      enabled          = true,
      config_file_path = "/etc/otel-config.yaml"
    }

    "extensions": {
      "sigv4auth" : {
        "region" : "eu-west-2",
        "service" : "aps"
      }
    }

  })
  }






