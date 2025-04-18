
resource "aws_dynamodb_table" "dynamodb-table" {
  name           = var.name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = var.hash_key
  range_key      = var.range_key

  dynamic "attribute" {
    for_each = var.attributes
    content {
      name = attribute.value.name
      type = attribute.value.type
    }
  }

  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}
