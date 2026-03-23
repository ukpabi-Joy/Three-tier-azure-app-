# --- MySQL Flexible Server (Primary - Zone 1) ---
resource "azurerm_mysql_flexible_server" "mysql_primary_jukpabi" {
  name                   = "mysql-primary-jukpabi"
  resource_group_name    = var.resource_group_name
  location               = var.location
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  sku_name               = var.mysql_sku
  version                = var.mysql_version
  delegated_subnet_id    = var.db_subnet_1_id
  private_dns_zone_id    = var.mysql_dns_zone_id
  backup_retention_days  = var.backup_retention_days
  zone                   = "1"

  high_availability {
    mode                      = "ZoneRedundant"
    standby_availability_zone = "2"
  }

  tags = {
    tier = "database"
    role = "primary"
  }

  depends_on = [var.dns_vnet_link_id]
}

# --- MySQL Database ---
resource "azurerm_mysql_flexible_database" "appdb_jukpabi" {
  name                = var.db_name
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_primary_jukpabi.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

# --- MySQL Firewall Rule (Allow App Tier) ---
resource "azurerm_mysql_flexible_server_firewall_rule" "allow_app_tier_jukpabi" {
  name                = "allow-app-tier-jukpabi"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_primary_jukpabi.name
  start_ip_address    = "10.0.3.0"
  end_ip_address      = "10.0.4.255"
}
