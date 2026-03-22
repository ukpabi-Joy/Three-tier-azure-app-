# ==========================================
# WEB TIER NSG
# Allows: HTTP (80) and SSH (22) from internet
# ==========================================
resource "azurerm_network_security_group" "web_nsg_jukpabi" {
  name                = "web-nsg-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow HTTP from internet
  security_rule {
    name                       = "allow-http"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow SSH from internet
  security_rule {
    name                       = "allow-ssh"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  # Allow App Gateway health probes
  security_rule {
    name                       = "allow-appgw-probes"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "65200-65535"
    source_address_prefix      = "GatewayManager"
    destination_address_prefix = "*"
  }

  # Deny all other inbound
  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ==========================================
# APP TIER NSG
# Allows: port 3001 from Web Tier only
# ==========================================
resource "azurerm_network_security_group" "app_nsg_jukpabi" {
  name                = "app-nsg-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow port 3001 from Web Tier only
  security_rule {
    name                       = "allow-web-tier"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3001"
    source_address_prefix      = "10.0.1.0/23"
    destination_address_prefix = "*"
  }

  # Allow SSH from Web Tier only
  security_rule {
    name                       = "allow-ssh-from-web"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.1.0/23"
    destination_address_prefix = "*"
  }

  # Deny all other inbound
  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ==========================================
# DB TIER NSG
# Allows: MySQL (3306) from App Tier only
# ==========================================
resource "azurerm_network_security_group" "db_nsg_jukpabi" {
  name                = "db-nsg-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Allow MySQL from App Tier only
  security_rule {
    name                       = "allow-app-tier"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.3.0/23"
    destination_address_prefix = "*"
  }

  # Deny all other inbound
  security_rule {
    name                       = "deny-all-inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# ==========================================
# NSG ASSOCIATIONS
# Link each NSG to its subnet
# ==========================================

# Web Subnet 1
resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc_1_jukpabi" {
  subnet_id                 = var.web_subnet_1_id
  network_security_group_id = azurerm_network_security_group.web_nsg_jukpabi.id
}

# Web Subnet 2
resource "azurerm_subnet_network_security_group_association" "web_nsg_assoc_2_jukpabi" {
  subnet_id                 = var.web_subnet_2_id
  network_security_group_id = azurerm_network_security_group.web_nsg_jukpabi.id
}

# App Subnet 1
resource "azurerm_subnet_network_security_group_association" "app_nsg_assoc_1_jukpabi" {
  subnet_id                 = var.app_subnet_1_id
  network_security_group_id = azurerm_network_security_group.app_nsg_jukpabi.id
}

# App Subnet 2
resource "azurerm_subnet_network_security_group_association" "app_nsg_assoc_2_jukpabi" {
  subnet_id                 = var.app_subnet_2_id
  network_security_group_id = azurerm_network_security_group.app_nsg_jukpabi.id
}

# DB Subnet 1
resource "azurerm_subnet_network_security_group_association" "db_nsg_assoc_1_jukpabi" {
  subnet_id                 = var.db_subnet_1_id
  network_security_group_id = azurerm_network_security_group.db_nsg_jukpabi.id
}

# DB Subnet 2
resource "azurerm_subnet_network_security_group_association" "db_nsg_assoc_2_jukpabi" {
  subnet_id                 = var.db_subnet_2_id
  network_security_group_id = azurerm_network_security_group.db_nsg_jukpabi.id
}
