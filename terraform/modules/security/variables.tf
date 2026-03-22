variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "web_subnet_1_id" {
  description = "Web subnet 1 ID"
  type        = string
}

variable "web_subnet_2_id" {
  description = "Web subnet 2 ID"
  type        = string
}

variable "app_subnet_1_id" {
  description = "App subnet 1 ID"
  type        = string
}

variable "app_subnet_2_id" {
  description = "App subnet 2 ID"
  type        = string
}

variable "db_subnet_1_id" {
  description = "DB subnet 1 ID"
  type        = string
}

variable "db_subnet_2_id" {
  description = "DB subnet 2 ID"
  type        = string
}
