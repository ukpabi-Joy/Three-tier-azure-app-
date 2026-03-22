# --- Application Gateway Public IP ---
output "application_gateway_ip" {
  description = "Public IP of the Application Gateway — access app here"
  value       = module.load_balancer.appgw_public_ip
}

# --- Internal Load Balancer Private IP ---
output "internal_lb_ip" {
  description = "Private IP of the Internal Load Balancer"
  value       = module.load_balancer.internal_lb_private_ip
}

# --- Web Tier VM IPs ---
output "web_vm_1_public_ip" {
  description = "Public IP of Web VM 1"
  value       = module.web_tier.web_vm_1_public_ip
}

output "web_vm_2_public_ip" {
  description = "Public IP of Web VM 2"
  value       = module.web_tier.web_vm_2_public_ip
}

# --- App Tier VM IPs ---
output "app_vm_1_private_ip" {
  description = "Private IP of App VM 1"
  value       = module.app_tier.app_vm_1_private_ip
}

output "app_vm_2_private_ip" {
  description = "Private IP of App VM 2"
  value       = module.app_tier.app_vm_2_private_ip
}

# --- Database Outputs ---
output "mysql_primary_fqdn" {
  description = "MySQL primary server FQDN"
  value       = module.db_tier.mysql_primary_fqdn
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = module.db_tier.mysql_database_name
}

# --- Resource Group ---
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg_jukpabi.name
}
