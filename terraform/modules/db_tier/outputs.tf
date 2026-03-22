output "mysql_primary_fqdn" {
  description = "MySQL primary server FQDN"
  value       = azurerm_mysql_flexible_server.mysql_primary_jukpabi.fqdn
}

output "mysql_primary_name" {
  description = "MySQL primary server name"
  value       = azurerm_mysql_flexible_server.mysql_primary_jukpabi.name
}

output "mysql_database_name" {
  description = "MySQL database name"
  value       = azurerm_mysql_flexible_database.appdb_jukpabi.name
}

output "mysql_admin_username" {
  description = "MySQL admin username"
  value       = azurerm_mysql_flexible_server.mysql_primary_jukpabi.administrator_login
}
