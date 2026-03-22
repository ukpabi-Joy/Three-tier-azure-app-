# ==========================================
# APPLICATION ACCESS
# ==========================================

output "application_gateway_ip" {
  description = "Public IP of Application Gateway — access the app here"
  value       = module.load_balancer.appgw_public_ip
}

output "internal_lb_ip" {
  description = "Private IP of Internal Load Balancer"
  value       = module.load_balancer.internal_lb_private_ip
}

# ==========================================
# WEB TIER
# ==========================================

output "web_vm_1_private_ip" {
  description = "Private IP of Web VM 1"
  value       = module.web_tier.web_vm_1_private_ip
}

output "web_vm_2_private_ip" {
  description = "Private IP of Web VM 2"
  value       = module.web_tier.web_vm_2_private_ip
}

output "web_vm_1_name" {
  description = "Web VM 1 name"
  value       = module.web_tier.web_vm_1_name
}

output "web_vm_2_name" {
  description = "Web VM 2 name"
  value       = module.web_tier.web_vm_2_name
}

# ==========================================
# APP TIER
# ==========================================

output "app_vm_1_private_ip" {
  description = "Private IP of App VM 1"
  value       = module.app_tier.app_vm_1_private_ip
}

output "app_vm_2_private_ip" {
  description = "Private IP of App VM 2"
  value       = module.app_tier.app_vm_2_private_ip
}

# ==========================================
# DATABASE
# ==========================================

output "mysql_primary_fqdn" {
  description = "MySQL primary server FQDN"
  value       = module.db_tier.mysql_primary_fqdn
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = module.db_tier.mysql_database_name
}

output "mysql_admin_username" {
  description = "MySQL admin username"
  value       = module.db_tier.mysql_admin_username
}

# ==========================================
# INFRASTRUCTURE
# ==========================================

output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.rg_jukpabi.name
}

output "vnet_name" {
  description = "Virtual Network name"
  value       = module.networking.vnet_name
}
