terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  subscription_id = var.subscription_id
}

# --- Resource Group ---
resource "azurerm_resource_group" "rg_jukpabi" {
  name     = var.resource_group_name
  location = var.location
}

# --- Networking Module ---
module "networking" {
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.rg_jukpabi.name
  location            = azurerm_resource_group.rg_jukpabi.location
  vnet_cidr           = var.vnet_cidr
  web_subnet_1_cidr   = var.web_subnet_1_cidr
  web_subnet_2_cidr   = var.web_subnet_2_cidr
  app_subnet_1_cidr   = var.app_subnet_1_cidr
  app_subnet_2_cidr   = var.app_subnet_2_cidr
  db_subnet_1_cidr    = var.db_subnet_1_cidr
  db_subnet_2_cidr    = var.db_subnet_2_cidr
}

# --- Security Module ---
module "security" {
  source              = "./modules/security"
  resource_group_name = azurerm_resource_group.rg_jukpabi.name
  location            = azurerm_resource_group.rg_jukpabi.location
  web_subnet_1_id     = module.networking.web_subnet_1_id
  web_subnet_2_id     = module.networking.web_subnet_2_id
  app_subnet_1_id     = module.networking.app_subnet_1_id
  app_subnet_2_id     = module.networking.app_subnet_2_id
  db_subnet_1_id      = module.networking.db_subnet_1_id
  db_subnet_2_id      = module.networking.db_subnet_2_id
}

# --- DB Tier Module ---
module "db_tier" {
  source              = "./modules/db_tier"
  resource_group_name = azurerm_resource_group.rg_jukpabi.name
  location            = azurerm_resource_group.rg_jukpabi.location
  db_subnet_1_id      = module.networking.db_subnet_1_id
  db_subnet_2_id      = module.networking.db_subnet_2_id
  mysql_dns_zone_id   = module.networking.mysql_dns_zone_id
  mysql_dns_zone_name = module.networking.mysql_dns_zone_name
  db_admin_username   = var.db_admin_username
  db_admin_password   = var.db_admin_password
  db_name             = var.db_name
  mysql_sku           = var.mysql_sku
}

# --- Web Tier Module ---
module "web_tier" {
  source              = "./modules/web_tier"
  resource_group_name = azurerm_resource_group.rg_jukpabi.name
  location            = azurerm_resource_group.rg_jukpabi.location
  web_subnet_1_id     = module.networking.web_subnet_1_id
  web_subnet_2_id     = module.networking.web_subnet_2_id
  web_nsg_id          = module.security.web_nsg_id
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
}

# --- App Tier Module ---
module "app_tier" {
  source              = "./modules/app_tier"
  resource_group_name = azurerm_resource_group.rg_jukpabi.name
  location            = azurerm_resource_group.rg_jukpabi.location
  app_subnet_1_id     = module.networking.app_subnet_1_id
  app_subnet_2_id     = module.networking.app_subnet_2_id
  app_nsg_id          = module.security.app_nsg_id
  vm_size             = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  db_host             = module.db_tier.mysql_primary_fqdn
  db_name             = var.db_name
  db_username         = var.db_admin_username
  db_password         = var.db_admin_password
}

# --- Load Balancer Module ---
module "load_balancer" {
  source              = "./modules/load_balancer"
  resource_group_name = azurerm_resource_group.rg_jukpabi.name
  location            = azurerm_resource_group.rg_jukpabi.location
  vnet_id             = module.networking.vnet_id
  web_subnet_1_id     = module.networking.web_subnet_1_id
  app_subnet_1_id     = module.networking.app_subnet_1_id
  web_nic_1_id        = module.web_tier.web_nic_1_id
  web_nic_2_id        = module.web_tier.web_nic_2_id
  app_nic_1_id        = module.app_tier.app_nic_1_id
  app_nic_2_id        = module.app_tier.app_nic_2_id
}
