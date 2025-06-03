output "ecs_name_" {
  value = (var.create_ecs_role == true
  ?(length(aws_iam_role.iam_role_ecs_task_execution) > 0 ? aws_iam_role.iam_role_ecs_task_execution[0].name : "") :
    (length(aws_iam_role.pipeline_role) > 0 ? aws_iam_role.pipeline_role[0].name : ""))

}
output "role_arn" {
  value = (var.create_ecs_role == true
  ?(length(aws_iam_role.iam_role_ecs_task_execution) > 0 ? aws_iam_role.iam_role_ecs_task_execution[0].arn : "") :
    (length(aws_iam_role.pipeline_role) > 0 ? aws_iam_role.pipeline_role[0].arn : ""))
}
output "codedeploy_arn" {
  value = (var.create_role_for_codedeploy == true ? (length(aws_iam_role.codeploy_role) > 0 ? aws_iam_role.codeploy_role[0].arn : "")
  : "")
}
output "ecs_task_role_arn" {
  value = (var.create_ecs_role == true ? (length(aws_iam_role.role_for_ecs_task) > 0 ? aws_iam_role.role_for_ecs_task[0].arn : "") :
  "")
}
output "ecs_task_role_name" {
  value = aws_iam_role.role_for_ecs_task.name
}
output "pipeline_role_name" {
  value = aws_iam_role.pipeline_role.name
}