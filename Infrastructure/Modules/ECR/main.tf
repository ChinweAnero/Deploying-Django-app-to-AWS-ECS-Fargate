
resource "aws_ecr_repository" "ecr" {
  name = var.erc_name
  force_delete = true
  tags = {
    Name = "ecr-repo"
  }
}