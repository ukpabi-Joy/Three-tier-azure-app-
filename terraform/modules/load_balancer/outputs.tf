output "appgw_public_ip" {
  description = "Application Gateway public IP address"
  value       = azurerm_public_ip.appgw_pip_jukpabi.ip_address
}

output "appgw_id" {
  description = "Application Gateway ID"
  value       = azurerm_application_gateway.appgw_jukpabi.id
}

output "internal_lb_private_ip" {
  description = "Internal Load Balancer private IP"
  value       = azurerm_lb.internal_lb_jukpabi.private_ip_address
}

output "internal_lb_id" {
  description = "Internal Load Balancer ID"
  value       = azurerm_lb.internal_lb_jukpabi.id
}

output "app_backend_pool_id" {
  description = "App tier backend pool ID"
  value       = azurerm_lb_backend_address_pool.app_backend_pool_jukpabi.id
}
