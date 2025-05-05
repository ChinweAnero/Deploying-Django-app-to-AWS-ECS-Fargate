
resource "aws_ecs_task_definition" "task_service" {
  family             = var.family
  network_mode       = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                = var.cpu
  memory             = var.memory
  execution_role_arn = var.execution_role_arn
  task_role_arn      = var.task_role_arn
  


  container_definitions = <<TASK_DEFINITION
    [
       {
        "logConfiguration": {
            "logDriver": "awslogs",
            "secretOptions": null,
            "options": {
              "awslogs-group": "task-definition-${var.name}",
              "awslogs-region": "${var.region}",
              "awslogs-stream-prefix": "ecs"
            }
          },

        "cpu": 0,
        "image": "${var.image}",
        "name": "${var.name_of_container}",
        "networkMode": "awsvpc",
        "portMappings": [
          {
            "containerPort": ${var.containerPort},
            "hostPort": ${var.hostPort}
          }
          ]
        }

    ]
TASK_DEFINITION
}

resource "aws_cloudwatch_log_group" "log_group_taskDef" {
  name = "task-definition-${var.name}"
  retention_in_days = 30
}