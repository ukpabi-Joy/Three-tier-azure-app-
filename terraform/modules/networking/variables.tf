variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "vnet_cidr" {
  description = "CIDR block for the VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "web_subnet_1_cidr" {
  description = "CIDR for web subnet zone 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "web_subnet_2_cidr" {
  description = "CIDR for web subnet zone 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "app_subnet_1_cidr" {
  description = "CIDR for app subnet zone 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "app_subnet_2_cidr" {
  description = "CIDR for app subnet zone 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "db_subnet_1_cidr" {
  description = "CIDR for db subnet zone 1"
  type        = string
  default     = "10.0.5.0/24"
}

variable "db_subnet_2_cidr" {
  description = "CIDR for db subnet zone 2"
  type        = string
  default     = "10.0.6.0/24"
}
