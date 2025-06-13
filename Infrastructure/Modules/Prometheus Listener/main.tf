# resource "aws_lb_listener" "prometheus-listener" {
#   #count = 1
#   load_balancer_arn = var.prometheus-loadbalancer
#   port              = "443"
#   protocol          = "HTTPS"
#
#   default_action {
#     type             = "forward"
#     target_group_arn = var.prometheus-target-group-arn
#   }
#   lifecycle {
#     ignore_changes = [default_action]
#   }
#  }