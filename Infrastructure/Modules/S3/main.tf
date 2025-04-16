
resource "aws_s3_bucket" "prod_s3_bucket" {
  bucket = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "Prod bucket"
    Environment = "Prod"
  }
}
resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.prod_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  depends_on = [aws_s3_bucket_ownership_controls.bucket_ownership]

  bucket = aws_s3_bucket.prod_s3_bucket.id
  acl    = "private"
}

