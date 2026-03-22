# --- Public IP for Web VM 1 ---
resource "azurerm_public_ip" "web_pip_1_jukpabi" {
  name                = "web-pip-1-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1"]

  tags = { tier = "web" }
}

# --- Public IP for Web VM 2 ---
resource "azurerm_public_ip" "web_pip_2_jukpabi" {
  name                = "web-pip-2-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["2"]

  tags = { tier = "web" }
}

# --- Network Interface for Web VM 1 ---
resource "azurerm_network_interface" "web_nic_1_jukpabi" {
  name                = "web-nic-1-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.web_subnet_1_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip_1_jukpabi.id
  }

  tags = { tier = "web" }
}

# --- Network Interface for Web VM 2 ---
resource "azurerm_network_interface" "web_nic_2_jukpabi" {
  name                = "web-nic-2-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.web_subnet_2_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.web_pip_2_jukpabi.id
  }

  tags = { tier = "web" }
}

# --- NIC NSG Association — Web VM 1 ---
resource "azurerm_network_interface_security_group_association" "web_nic_nsg_1_jukpabi" {
  network_interface_id      = azurerm_network_interface.web_nic_1_jukpabi.id
  network_security_group_id = var.web_nsg_id
}

# --- NIC NSG Association — Web VM 2 ---
resource "azurerm_network_interface_security_group_association" "web_nic_nsg_2_jukpabi" {
  network_interface_id      = azurerm_network_interface.web_nic_2_jukpabi.id
  network_security_group_id = var.web_nsg_id
}

# --- Web VM 1 (Zone 1) ---
resource "azurerm_linux_virtual_machine" "web_vm_1_jukpabi" {
  name                            = "web-vm-1-jukpabi"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  zone                            = "1"

  network_interface_ids = [
    azurerm_network_interface.web_nic_1_jukpabi.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs git nginx
    systemctl start nginx
    systemctl enable nginx
    echo "Web VM 1 ready" > /tmp/status.txt
  EOF
  )

  tags = {
    tier = "web"
    zone = "1"
  }
}

# --- Web VM 2 (Zone 2) ---
resource "azurerm_linux_virtual_machine" "web_vm_2_jukpabi" {
  name                            = "web-vm-2-jukpabi"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  zone                            = "2"

  network_interface_ids = [
    azurerm_network_interface.web_nic_2_jukpabi.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    apt-get update -y
    apt-get upgrade -y
    curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
    apt-get install -y nodejs git nginx
    systemctl start nginx
    systemctl enable nginx
    echo "Web VM 2 ready" > /tmp/status.txt
  EOF
  )

  tags = {
    tier = "web"
    zone = "2"
  }
}
