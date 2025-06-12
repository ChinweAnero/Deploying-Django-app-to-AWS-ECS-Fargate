output "taskDef_arn" {
  value = aws_ecs_task_definition.Prom_task_service.arn
  description = "arn of the task definition"
}
output "taskDef_family" {
  value = aws_ecs_task_definition.Prom_task_service.family
  description = "task definition family"
}