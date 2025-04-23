output "ecs_name" {
  value = aws_ecs_service.ecs_service.name
  description = "outputs ecs service name"
}
output "cluster_name" {
  value = var.cluster_id
}