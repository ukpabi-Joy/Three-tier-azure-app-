output "web_vm_1_public_ip" {
  description = "Public IP of Web VM 1"
  value       = azurerm_public_ip.web_pip_1_jukpabi.ip_address
}

output "web_vm_2_public_ip" {
  description = "Public IP of Web VM 2"
  value       = azurerm_public_ip.web_pip_2_jukpabi.ip_address
}

output "web_vm_1_private_ip" {
  description = "Private IP of Web VM 1"
  value       = azurerm_network_interface.web_nic_1_jukpabi.private_ip_address
}

output "web_vm_2_private_ip" {
  description = "Private IP of Web VM 2"
  value       = azurerm_network_interface.web_nic_2_jukpabi.private_ip_address
}

output "web_nic_1_id" {
  description = "Web NIC 1 ID for load balancer backend pool"
  value       = azurerm_network_interface.web_nic_1_jukpabi.id
}

output "web_nic_2_id" {
  description = "Web NIC 2 ID for load balancer backend pool"
  value       = azurerm_network_interface.web_nic_2_jukpabi.id
}
