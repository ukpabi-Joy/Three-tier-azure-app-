variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_id" {
  description = "VNet ID from networking module"
  type        = string
}

variable "web_subnet_1_id" {
  description = "Web subnet 1 ID for App Gateway"
  type        = string
}

variable "app_subnet_1_id" {
  description = "App subnet 1 ID for Internal LB"
  type        = string
}

variable "web_nic_1_id" {
  description = "Web NIC 1 ID for backend pool"
  type        = string
}

variable "web_nic_2_id" {
  description = "Web NIC 2 ID for backend pool"
  type        = string
}

variable "app_nic_1_id" {
  description = "App NIC 1 ID for backend pool"
  type        = string
}

variable "app_nic_2_id" {
  description = "App NIC 2 ID for backend pool"
  type        = string
}
