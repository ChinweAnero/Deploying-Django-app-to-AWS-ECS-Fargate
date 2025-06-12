resource "aws_ecs_task_definition" "Prom_task_service" {
  family                   = var.family
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = "prometheus"
      image     = "707798379596.dkr.ecr.eu-west-2.amazonaws.com/prometheus-monitoring:latest"
      essential = true
      portMappings = [
        {
          containerPort = 9090
          hostPort      = 9090
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/prometheus"
          awslogs-region        = var.region
          awslogs-stream-prefix = "prometheus"
        }
      }
      authorization_config = {
           credentials_parameter = "arn:aws:secretsmanager:eu-west-2:707798379596:secret:dockerhub-credentials-nOk8mq"

        }
    }
  ])

}

resource "aws_cloudwatch_log_group" "log_group_taskDef" {
  name              = "Prom-task-definition-${var.name}"
  retention_in_days = 30
}
