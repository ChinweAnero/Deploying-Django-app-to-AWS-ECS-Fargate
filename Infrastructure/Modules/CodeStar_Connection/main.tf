
resource "aws_codestarconnections_connection" "django_app" {
  name          = var.codestar_name
  provider_type = "GitHub"
}