output "load_balancer_arn" {
  value = (var.create_load_balancer == true
  ? (length(aws_lb.load_B) > 0 ? aws_lb.load_B[0].arn : "") : "")
}

output "target_group_arn" {
  value = (var.create_target_group == true
  ? (length(aws_lb_target_group.ip_target_group) > 0 ? aws_lb_target_group.ip_target_group[0].arn : "") : "")
}

output "target_group_name" {
  value = (var.create_target_group == true
  ? (length(aws_lb_target_group.ip_target_group) > 0 ? aws_lb_target_group.ip_target_group[0].name : "") : "")
}

output "listener_arn" {
  value = (var.create_load_balancer == true
  ? (length(aws_lb_listener.http) > 0 ? aws_lb_listener.http[0].arn : "") : "")
}
output "load_balancer_dns" {
  value = (var.create_load_balancer == true
  ? (length(aws_lb.load_B) > 0 ? aws_lb.load_B[0].dns_name : "") : "")
}
