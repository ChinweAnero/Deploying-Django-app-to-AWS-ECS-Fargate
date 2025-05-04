output "weather_app_url" {
  value = module.App_load_balancer_client.load_balancer_dns
  description = "url of the application"
}