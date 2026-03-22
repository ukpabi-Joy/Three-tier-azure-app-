output "app_vm_1_private_ip" {
  description = "Private IP of App VM 1"
  value       = azurerm_network_interface.app_nic_1_jukpabi.private_ip_address
}

output "app_vm_2_private_ip" {
  description = "Private IP of App VM 2"
  value       = azurerm_network_interface.app_nic_2_jukpabi.private_ip_address
}

output "app_nic_1_id" {
  description = "App NIC 1 ID for load balancer backend pool"
  value       = azurerm_network_interface.app_nic_1_jukpabi.id
}

output "app_nic_2_id" {
  description = "App NIC 2 ID for load balancer backend pool"
  value       = azurerm_network_interface.app_nic_2_jukpabi.id
}

output "app_vm_1_id" {
  description = "App VM 1 resource ID"
  value       = azurerm_linux_virtual_machine.app_vm_1_jukpabi.id
}

output "app_vm_2_id" {
  description = "App VM 2 resource ID"
  value       = azurerm_linux_virtual_machine.app_vm_2_jukpabi.id
}
