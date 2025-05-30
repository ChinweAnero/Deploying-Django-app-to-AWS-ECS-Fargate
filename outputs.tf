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