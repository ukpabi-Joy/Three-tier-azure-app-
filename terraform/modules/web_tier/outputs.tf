output "web_vm_1_private_ip" {
  description = "Private IP of Web VM 1"
  value       = azurerm_network_interface.web_nic_1_jukpabi.private_ip_address
}

output "web_vm_2_private_ip" {
  description = "Private IP of Web VM 2"
  value       = azurerm_network_interface.web_nic_2_jukpabi.private_ip_address
}

output "web_nic_1_id" {
  description = "Web NIC 1 ID for App Gateway backend pool"
  value       = azurerm_network_interface.web_nic_1_jukpabi.id
}

output "web_nic_2_id" {
  description = "Web NIC 2 ID for App Gateway backend pool"
  value       = azurerm_network_interface.web_nic_2_jukpabi.id
}

output "web_vm_1_name" {
  description = "Web VM 1 name"
  value       = azurerm_linux_virtual_machine.web_vm_1_jukpabi.name
}

output "web_vm_2_name" {
  description = "Web VM 2 name"
  value       = azurerm_linux_virtual_machine.web_vm_2_jukpabi.name
}
