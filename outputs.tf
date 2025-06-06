output "weather_app_url" {
  value = module.App_load_balancer_client.load_balancer_dns
  description = "url of the application"
}
output "cloudwatch_agent_value" {
  value = module.cloudwatch_agent.parameter_store_value
  sensitive = true
}
output "cloudwatch_agent_id" {
  value = module.cloudwatch_agent.parameter_store_id
}
output "cloudwatch_agent_log_group_name" {
  value = module.cloudwatch_agent_log_group.cloudwatch_agent_log_group_name
}
output "prometheus_workspace_id" {
  value = module.prometheus_workspace.workspace_id
}
# output "target_group_arn_green" {
#   value = (var.create_target_group == true
#   ? (length(module.prometheus_target_group_green.ip_target_group) > 0 ? module.prometheus_target_group_green.ip_target_group[0].arn : "") : "")
# }
# output "target_group_arn_blue" {
#   value = (var.create_target_group == true
#   ? (length(module.prometheus_target_group_blue.ip_target_group) > 0 ? module.prometheus_target_group_blue.ip_target_group[0].arn : "") : "")
# }