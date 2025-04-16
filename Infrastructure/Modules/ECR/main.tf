
resource "aws_ecr_repository" "ecr" {
  name = var.erc_name
  tags = {
    Name = "ecr-repo"
  }
}