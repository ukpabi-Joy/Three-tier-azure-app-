variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "web_subnet_1_id" {
  description = "Web subnet 1 ID from networking module"
  type        = string
}

variable "web_subnet_2_id" {
  description = "Web subnet 2 ID from networking module"
  type        = string
}

variable "web_nsg_id" {
  description = "Web NSG ID from security module"
  type        = string
}

variable "vm_size" {
  description = "Size of the web tier VMs"
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

variable "app_backend_url" {
  description = "Internal Load Balancer URL for backend API"
  type        = string
  default     = "http://10.0.3.10:3001"
}
