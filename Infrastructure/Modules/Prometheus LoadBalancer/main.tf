
resource "aws_lb_listener_rule" "expose-prometheus" {
  listener_arn = var.listener_arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = var.prometheus-target-group-arn
  }

  condition {
    path_pattern {
      values = ["/prometheus*"]
    }
  }
}
