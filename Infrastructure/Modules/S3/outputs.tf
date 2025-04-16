output "bucket_id" {
  value       = aws_s3_bucket.prod_s3_bucket.id
  description = "the id of the bucket"
}
output "bucket_arn" {
  value = aws_s3_bucket.prod_s3_bucket.arn
}