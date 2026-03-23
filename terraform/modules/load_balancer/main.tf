# ==========================================
# PUBLIC APPLICATION GATEWAY
# Uses dedicated subnet — required for v2
# ==========================================

# --- Public IP for Application Gateway ---
resource "azurerm_public_ip" "appgw_pip_jukpabi" {
  name                = "appgw-pip-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = { role = "app-gateway" }
}

# --- Application Gateway ---
resource "azurerm_application_gateway" "appgw_jukpabi" {
  name                = "appgw-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name

  sku {
    name     = "Standard_v2"
    tier     = "Standard_v2"
    capacity = 2
  }

  # Uses dedicated App Gateway subnet
  gateway_ip_configuration {
    name      = "appgw-ip-config"
    subnet_id = var.appgw_subnet_id
  }

  # Frontend Public IP
  frontend_ip_configuration {
    name                 = "appgw-frontend-ip"
    public_ip_address_id = azurerm_public_ip.appgw_pip_jukpabi.id
  }

  # Frontend Port — listens on port 80
  frontend_port {
    name = "appgw-frontend-port"
    port = 80
  }

  # Backend Pool — Web Tier VMs
  backend_address_pool {
    name = "web-backend-pool"
  }

  # Backend HTTP Settings
  backend_http_settings {
    name                  = "appgw-http-settings"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 60
  }

  # Health Probe for Web VMs
  probe {
    name                = "web-health-probe"
    protocol            = "Http"
    path                = "/"
    host                = "127.0.0.1"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
  }

  # HTTP Listener
  http_listener {
    name                           = "appgw-http-listener"
    frontend_ip_configuration_name = "appgw-frontend-ip"
    frontend_port_name             = "appgw-frontend-port"
    protocol                       = "Http"
  }

  # Routing Rule
  request_routing_rule {
    name                       = "appgw-routing-rule"
    rule_type                  = "Basic"
    priority                   = 100
    http_listener_name         = "appgw-http-listener"
    backend_address_pool_name  = "web-backend-pool"
    backend_http_settings_name = "appgw-http-settings"
  }

  tags = { role = "app-gateway" }
}

# ==========================================
# INTERNAL LOAD BALANCER
# Private only — no public IP
# Routes port 3001 to App Tier VMs
# ==========================================

resource "azurerm_lb" "internal_lb_jukpabi" {
  name                = "internal-lb-jukpabi"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "internal-lb-frontend"
    subnet_id                     = var.app_subnet_1_id
    private_ip_address_allocation = "Dynamic"
    private_ip_address_version    = "IPv4"
  }

  tags = { role = "internal-lb" }
}

# --- Backend Address Pool for App VMs ---
resource "azurerm_lb_backend_address_pool" "app_backend_pool_jukpabi" {
  name            = "app-backend-pool-jukpabi"
  loadbalancer_id = azurerm_lb.internal_lb_jukpabi.id
}

# --- Health Probe for App VMs ---
resource "azurerm_lb_probe" "app_health_probe_jukpabi" {
  name            = "app-health-probe-jukpabi"
  loadbalancer_id = azurerm_lb.internal_lb_jukpabi.id
  protocol        = "Tcp"
  port            = 3001
}

# --- Load Balancing Rule — port 3001 ---
resource "azurerm_lb_rule" "app_lb_rule_jukpabi" {
  name                           = "app-lb-rule-jukpabi"
  loadbalancer_id                = azurerm_lb.internal_lb_jukpabi.id
  protocol                       = "Tcp"
  frontend_port                  = 3001
  backend_port                   = 3001
  frontend_ip_configuration_name = "internal-lb-frontend"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.app_backend_pool_jukpabi.id]
  probe_id                       = azurerm_lb_probe.app_health_probe_jukpabi.id
  enable_floating_ip             = false
  idle_timeout_in_minutes        = 4
}

# --- Associate App NIC 1 with Internal LB ---
resource "azurerm_network_interface_backend_address_pool_association" "app_nic_1_lb_assoc_jukpabi" {
  network_interface_id    = var.app_nic_1_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.app_backend_pool_jukpabi.id
}

# --- Associate App NIC 2 with Internal LB ---
resource "azurerm_network_interface_backend_address_pool_association" "app_nic_2_lb_assoc_jukpabi" {
  network_interface_id    = var.app_nic_2_id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.app_backend_pool_jukpabi.id
}
