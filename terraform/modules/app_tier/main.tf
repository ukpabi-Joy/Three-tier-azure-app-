# --- Network Interface for App VM 1 ---
# NO public IP — private only!
resource "azurerm_network_interface" "app_nic_1_jukpabi" {
  name                = "app-nic-1-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.app_subnet_1_id
    private_ip_address_allocation = "Dynamic"
    # No public_ip_address_id — intentionally private
  }

  tags = { tier = "app" }
}

# --- Network Interface for App VM 2 ---
# NO public IP — private only!
resource "azurerm_network_interface" "app_nic_2_jukpabi" {
  name                = "app-nic-2-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.app_subnet_2_id
    private_ip_address_allocation = "Dynamic"
    # No public_ip_address_id — intentionally private
  }

  tags = { tier = "app" }
}

# --- NIC NSG Association — App VM 1 ---
resource "azurerm_network_interface_security_group_association" "app_nic_nsg_1_jukpabi" {
  network_interface_id      = azurerm_network_interface.app_nic_1_jukpabi.id
  network_security_group_id = var.app_nsg_id
}

# --- NIC NSG Association — App VM 2 ---
resource "azurerm_network_interface_security_group_association" "app_nic_nsg_2_jukpabi" {
  network_interface_id      = azurerm_network_interface.app_nic_2_jukpabi.id
  network_security_group_id = var.app_nsg_id
}

# --- App VM 1 (Zone 1) ---
resource "azurerm_linux_virtual_machine" "app_vm_1_jukpabi" {
  name                            = "app-vm-1-jukpabi"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  zone                            = "1"

  network_interface_ids = [
    azurerm_network_interface.app_nic_1_jukpabi.id
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
    apt-get install -y nodejs git
    npm install -g pm2
    # Create environment file for the app
    cat > /etc/app.env <<ENVFILE
    DB_HOST=${var.db_host}
    DB_NAME=${var.db_name}
    DB_USER=${var.db_username}
    DB_PASS=${var.db_password}
    PORT=3001
    NODE_ENV=production
    ENVFILE
    echo "App VM 1 ready" > /tmp/status.txt
  EOF
  )

  tags = {
    tier = "app"
    zone = "1"
  }
}

# --- App VM 2 (Zone 2) ---
resource "azurerm_linux_virtual_machine" "app_vm_2_jukpabi" {
  name                            = "app-vm-2-jukpabi"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = false
  zone                            = "2"

  network_interface_ids = [
    azurerm_network_interface.app_nic_2_jukpabi.id
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
    apt-get install -y nodejs git
    npm install -g pm2
    # Create environment file for the app
    cat > /etc/app.env <<ENVFILE
    DB_HOST=${var.db_host}
    DB_NAME=${var.db_name}
    DB_USER=${var.db_username}
    DB_PASS=${var.db_password}
    PORT=3001
    NODE_ENV=production
    ENVFILE
    echo "App VM 2 ready" > /tmp/status.txt
  EOF
  )

  tags = {
    tier = "app"
    zone = "2"
  }
}
