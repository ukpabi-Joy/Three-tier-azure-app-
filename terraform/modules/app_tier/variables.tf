variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "app_subnet_1_id" {
  description = "App subnet 1 ID from networking module"
  type        = string
}

variable "app_subnet_2_id" {
  description = "App subnet 2 ID from networking module"
  type        = string
}

variable "app_nsg_id" {
  description = "App NSG ID from security module"
  type        = string
}

variable "vm_size" {
  description = "Size of the app tier VMs"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "VM admin username"
  type        = string
  default     = "azureuser"
}

variable "admin_password" {
  description = "VM admin password"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "MySQL database host FQDN"
  type        = string
}

variable "db_name" {
  description = "MySQL database name"
  type        = string
}

variable "db_username" {
  description = "MySQL database username"
  type        = string
}

variable "db_password" {
  description = "MySQL database password"
  type        = string
  sensitive   = true
}
