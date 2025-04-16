output "ecr_repo_url" {
  value = aws_ecr_repository.ecr.repository_url
  description = "url of the ecr repo"
}
output "ecr_repo_arn" {
  value = aws_ecr_repository.ecr.arn
  description = "arn of the repo"
}