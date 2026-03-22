output "vnet_id" {
  description = "VNet ID"
  value       = azurerm_virtual_network.vnet_jukpabi.id
}

output "vnet_name" {
  description = "VNet name"
  value       = azurerm_virtual_network.vnet_jukpabi.name
}

output "web_subnet_1_id" {
  description = "Web subnet 1 ID"
  value       = azurerm_subnet.web_subnet_1_jukpabi.id
}

output "web_subnet_2_id" {
  description = "Web subnet 2 ID"
  value       = azurerm_subnet.web_subnet_2_jukpabi.id
}

output "app_subnet_1_id" {
  description = "App subnet 1 ID"
  value       = azurerm_subnet.app_subnet_1_jukpabi.id
}

output "app_subnet_2_id" {
  description = "App subnet 2 ID"
  value       = azurerm_subnet.app_subnet_2_jukpabi.id
}

output "db_subnet_1_id" {
  description = "DB subnet 1 ID"
  value       = azurerm_subnet.db_subnet_1_jukpabi.id
}

output "db_subnet_2_id" {
  description = "DB subnet 2 ID"
  value       = azurerm_subnet.db_subnet_2_jukpabi.id
}

output "mysql_dns_zone_id" {
  description = "MySQL Private DNS Zone ID"
  value       = azurerm_private_dns_zone.mysql_dns_jukpabi.id
}

output "mysql_dns_zone_name" {
  description = "MySQL Private DNS Zone name"
  value       = azurerm_private_dns_zone.mysql_dns_jukpabi.name
}

output "dns_vnet_link_id" {
  description = "DNS VNet link ID — passed to db_tier to ensure DNS is linked before MySQL"
  value       = azurerm_private_dns_zone_virtual_network_link.dns_link_jukpabi.id
}
