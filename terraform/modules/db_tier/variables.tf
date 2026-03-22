variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "db_subnet_1_id" {
  description = "DB subnet 1 ID from networking module"
  type        = string
}

variable "db_subnet_2_id" {
  description = "DB subnet 2 ID from networking module"
  type        = string
}

variable "mysql_dns_zone_id" {
  description = "Private DNS Zone ID from networking module"
  type        = string
}

variable "mysql_dns_zone_name" {
  description = "Private DNS Zone name from networking module"
  type        = string
}

variable "dns_vnet_link_id" {
  description = "DNS VNet link ID — ensures link exists before MySQL server"
  type        = string
}

variable "db_admin_username" {
  description = "MySQL administrator username"
  type        = string
  default     = "mysqladmin"
}

variable "db_admin_password" {
  description = "MySQL administrator password"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "Name of the database to create"
  type        = string
  default     = "appdb"
}

variable "mysql_sku" {
  description = "MySQL Flexible Server SKU"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "mysql_version" {
  description = "MySQL version"
  type        = string
  default     = "8.0.21"
}

variable "backup_retention_days" {
  description = "Backup retention in days"
  type        = number
  default     = 7
}
