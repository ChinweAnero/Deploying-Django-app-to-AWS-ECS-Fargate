output "ecs_name" {
  value = aws_ecs_service.ecs_service.name
  description = "outputs ecs service name"
}