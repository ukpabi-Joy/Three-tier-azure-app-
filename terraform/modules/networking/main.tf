# --- Virtual Network ---
resource "azurerm_virtual_network" "vnet_jukpabi" {
  name                = "vnet-jukpabi"
  address_space       = [var.vnet_cidr]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# --- Web Subnet Zone 1 (Public) ---
resource "azurerm_subnet" "web_subnet_1_jukpabi" {
  name                 = "web-subnet-1-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.web_subnet_1_cidr]
}

# --- Web Subnet Zone 2 (Public) ---
resource "azurerm_subnet" "web_subnet_2_jukpabi" {
  name                 = "web-subnet-2-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.web_subnet_2_cidr]
}

# --- App Subnet Zone 1 (Private) ---
resource "azurerm_subnet" "app_subnet_1_jukpabi" {
  name                 = "app-subnet-1-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.app_subnet_1_cidr]
}

# --- App Subnet Zone 2 (Private) ---
resource "azurerm_subnet" "app_subnet_2_jukpabi" {
  name                 = "app-subnet-2-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.app_subnet_2_cidr]
}

# --- DB Subnet Zone 1 (Private — Delegated to MySQL) ---
resource "azurerm_subnet" "db_subnet_1_jukpabi" {
  name                 = "db-subnet-1-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.db_subnet_1_cidr]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# --- DB Subnet Zone 2 (Private — Delegated to MySQL) ---
resource "azurerm_subnet" "db_subnet_2_jukpabi" {
  name                 = "db-subnet-2-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = [var.db_subnet_2_cidr]

  delegation {
    name = "mysql-delegation"
    service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
  }
}

# --- App Gateway Subnet (required by Azure Application Gateway) ---
resource "azurerm_subnet" "appgw_subnet_jukpabi" {
  name                 = "appgw-subnet-jukpabi"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_jukpabi.name
  address_prefixes     = ["10.0.7.0/24"]
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
