output "codestar_arn" {
  value = aws_codestarconnections_connection.django_app.arn
  description = "arn of the codestar connection"
}