output "web_nsg_id" {
  description = "Web Tier NSG ID"
  value       = azurerm_network_security_group.web_nsg_jukpabi.id
}

output "app_nsg_id" {
  description = "App Tier NSG ID"
  value       = azurerm_network_security_group.app_nsg_jukpabi.id
}

output "db_nsg_id" {
  description = "DB Tier NSG ID"
  value       = azurerm_network_security_group.db_nsg_jukpabi.id
}
