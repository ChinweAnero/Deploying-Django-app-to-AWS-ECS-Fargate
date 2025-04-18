
resource "aws_ecs_cluster" "cluster" {
  name = "esc-${var.cluster_name}"

}