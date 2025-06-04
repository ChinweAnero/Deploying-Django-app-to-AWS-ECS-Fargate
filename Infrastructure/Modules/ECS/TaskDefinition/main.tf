
resource "aws_ecs_task_definition" "task_service" {
  family             = var.family
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn

  container_definitions = jsonencode([
    {
      logConfiguration = {
        logDriver     = "awslogs"
        secretOptions = null
        options = {
          awslogs-group         = "task-definition-${var.name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
      cpu   = 0
      image = var.image
      name  = var.name_of_container
      portMappings = [
        {
          containerPort = var.containerPort
          hostPort      = var.hostPort
        }
      ]
    },
    {
      name      = "cwagent"
      image     = "amazon/cloudwatch-agent:latest"
      essential = false
      environment = [
        {
          name = "CW_CONFIG_CONTENT"
          value = jsonencode({
            agent = {
              region = "eu-west-2"
            },
            metrics = {
              metrics_collected = {
                prometheus = {
                  prometheus_config_path = "/opt/aws/amazon-cloudwatch-agent/etc/prometheus.yml"
                }
              }
              append_dimensions = {
                ClusterName = var.clusterName
              }
              metrics_destinations = {
                  amp = {
                    workspace_id = "ws-9e3281be-1f50-4da3-9eb8-e1576377f610"
                  }
                }
              }
            })
         }

        ],
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.aws_cloudwatch_agent_log_group_name,
          awslogs-region        = var.region,
          awslogs-stream-prefix = "cwagent"
        }
      }

        name      = "otel-collector"
        image     = "707798379596.dkr.ecr.eu-west-2.amazonaws.com/otel-config-repo:latest"
        essential = false
        environment = [
          {
            name  = "AWS_REGION"
            value = var.region
          },
          {
            name  = "OTEL_CONFIG"
            value = "/etc/otel-config.yaml"
          }
        ]
        logConfiguration = {
          logDriver = "awslogs"
          options = {
            awslogs-group         = var.otel_collector_log
            awslogs-region        = var.region
            awslogs-stream-prefix = "otel"
          }
        }
      }
  ])
}

resource "aws_cloudwatch_log_group" "log_group_taskDef" {
  name = "task-definition-${var.name}"
  retention_in_days = 30
}