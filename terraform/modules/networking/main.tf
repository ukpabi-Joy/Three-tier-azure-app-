# --- Virtual Network ---
resource "azurerm_virtual_network" "vnet_jukpabi" {
  name                = "vnet-jukpabi"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# --- Web Subnet 1 (Public - Zone 1) ---
resource "azurerm_subnet" "web_subnet_1_jukpabi" {
  name                 = "web-subnet-1-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.web_subnet_1_cidr]
}

# --- Web Subnet 2 (Public - Zone 2) ---
resource "azurerm_subnet" "web_subnet_2_jukpabi" {
  name                 = "web-subnet-2-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.web_subnet_2_cidr]
}

# --- App Subnet 1 (Private - Zone 1) ---
resource "azurerm_subnet" "app_subnet_1_jukpabi" {
  name                 = "app-subnet-1-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.app_subnet_1_cidr]
}

# --- App Subnet 2 (Private - Zone 2) ---
resource "azurerm_subnet" "app_subnet_2_jukpabi" {
  name                 = "app-subnet-2-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.app_subnet_2_cidr]
}

# --- DB Subnet 1 (Private - Zone 1 - Delegated to MySQL) ---
resource "azurerm_subnet" "db_subnet_1_jukpabi" {
  name                 = "db-subnet-1-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.db_subnet_1_cidr]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# --- DB Subnet 2 (Private - Zone 2 - Delegated to MySQL) ---
resource "azurerm_subnet" "db_subnet_2_jukpabi" {
  name                 = "db-subnet-2-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.db_subnet_2_cidr]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name = "Microsoft.DBforMySQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action"
      ]
    }
  }
}

# --- App Gateway Subnet (dedicated — required for App Gateway v2) ---
resource "azurerm_subnet" "appgw_subnet_jukpabi" {
  name                 = "appgw-subnet-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.appgw_subnet_cidr]
}

# --- Private DNS Zone for MySQL ---
resource "azurerm_private_dns_zone" "mysql_dns_jukpabi" {
  name                = "jukpabi.private.mysql.database.azure.com"
  resource_group_name = var.resource_group_name
}

# --- Link DNS Zone to VNet ---
resource "azurerm_private_dns_zone_virtual_network_link" "dns_link_jukpabi" {
  name                  = "dns-link-jukpabi"
  private_dns_zone_name = azurerm_private_dns_zone.mysql_dns_jukpabi.name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = azurerm_virtual_network.vnet_jukpabi.id
}
