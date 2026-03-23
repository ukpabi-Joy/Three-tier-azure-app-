# ==========================================
# GLOBAL VARIABLES
# ==========================================

variable "subscription_id" {
  description = "Azure subscription ID"
  type        = string
  default     = "d4bef32a-3fbb-44ae-a0af-e74ab527a27a"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US 2"
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
  default     = "three-tier-rg-jukpabi"
}

# ==========================================
# NETWORK VARIABLES
# ==========================================

variable "vnet_cidr" {
  description = "VNet CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_subnet_1_cidr" {
  description = "Web subnet 1 CIDR — Zone 1 Public"
  type        = string
  default     = "10.0.1.0/24"
}

variable "web_subnet_2_cidr" {
  description = "Web subnet 2 CIDR — Zone 2 Public"
  type        = string
  default     = "10.0.2.0/24"
}

variable "app_subnet_1_cidr" {
  description = "App subnet 1 CIDR — Zone 1 Private"
  type        = string
  default     = "10.0.3.0/24"
}

variable "app_subnet_2_cidr" {
  description = "App subnet 2 CIDR — Zone 2 Private"
  type        = string
  default     = "10.0.4.0/24"
}

variable "db_subnet_1_cidr" {
  description = "DB subnet 1 CIDR — Zone 1 Private"
  type        = string
  default     = "10.0.5.0/24"
}

variable "db_subnet_2_cidr" {
  description = "DB subnet 2 CIDR — Zone 2 Private"
  type        = string
  default     = "10.0.6.0/24"
}

variable "appgw_subnet_cidr" {
  description = "CIDR for Application Gateway dedicated subnet"
  type        = string
  default     = "10.0.7.0/24"
}

# ==========================================
# VM VARIABLES
# ==========================================

variable "vm_size" {
  description = "VM size for all tiers"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "VM admin password — set in terraform.tfvars"
  type        = string
  sensitive   = true
}

# ==========================================
# DATABASE VARIABLES
# ==========================================

variable "db_admin_username" {
  description = "MySQL admin username"
  type        = string
  default     = "mysqladmin"
}

variable "db_admin_password" {
  description = "MySQL admin password — set in terraform.tfvars"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "appdb"
}

variable "mysql_sku" {
  description = "MySQL Flexible Server SKU"
  type        = string
  default     = "B_Standard_B1ms"
}
