resource "aws_ssm_parameter" "cloudwatch_agent" {
  name = var.cloudwatch_agent_name
  type = var.cloudwatch_agent_type

  value = jsonencode({
    metrics = {
      metrics_collected = {
        prometheus = {
          prometheus_config_path = "/opt/aws/amazon-cloudwatch-agent/etc/prometheus.yml",

        }
      },
      "metrics_destinations" = {
        "amp" = {
          "region"       = "eu-west-2",
          "workspace_id" = "ws-f415a87f-1c1c-4f85-9e39-1bb45d471db2"
        }
      },
      "append_dimensions": {
      #"TaskId": "aws:ecs:task-id",
      "ClusterName" = var.clusterName
      }

    }
  })
}


