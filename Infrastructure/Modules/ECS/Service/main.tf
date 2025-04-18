
resource "aws_ecs_service" "ecs_service" {
  name            = "ECS-Service-${var.name}"
  cluster         = var.cluster_id
  task_definition = var.taskdef
  desired_count   = 3
  launch_type = "FARGATE"
  health_check_grace_period_seconds = 10

  network_configuration {
    subnets = [var.subnets[0], var.subnets[1]]
    security_groups = [var.security_groups]
  }

  load_balancer {
    target_group_arn = var.alb_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}
