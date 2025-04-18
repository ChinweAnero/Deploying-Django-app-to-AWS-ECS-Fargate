output "dynamodb_arn" {
  value = aws_dynamodb_table.dynamodb-table.arn
  description = "arn of the dynamodb"
}
output "dynamodb_name" {
  value = aws_dynamodb_table.dynamodb-table.name
  description = "dynamodb name"
}