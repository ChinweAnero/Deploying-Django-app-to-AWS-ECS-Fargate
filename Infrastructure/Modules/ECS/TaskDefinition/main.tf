
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
              metrics = {
                metrics_collected = {
                  prometheus = {
                    prometheus_config_path = "/opt/aws/amazon-cloudwatch-agent/etc/prometheus.yml"
                  }
                }
                metrics_destinations = {
                  amp = {
                    region       = "eu-west-2"
                    workspace_id = "ws-f415a87f-1c1c-4f85-9e39-1bb45d471db2"
                  }
                }
                append_dimensions = {
                  ClusterName = var.clusterName
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
    }
  ])
}

resource "aws_cloudwatch_log_group" "log_group_taskDef" {
  name = "task-definition-${var.name}"
  retention_in_days = 30
}