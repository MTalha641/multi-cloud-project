# Provider configuration for Azure
# provider "azurerm" {
#   features {}
# }

# Resource bnayen hain for grouping
resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = var.azure_region
}

# Public static ip assign ki ha to load balancer, vm and vn
resource "azurerm_public_ip" "example" {
  name                = "example-public-ip"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# yahan front end bhi static ip use kr rha jo pehle bnaye for traffic routing
resource "azurerm_lb" "example" {
  name                = "example-lb"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  
  frontend_ip_configuration {
    name                 = "example-frontend-ip"
    public_ip_address_id = azurerm_public_ip.example.id
  }
}

# VM Ka group bnaya ha for load balancing
resource "azurerm_lb_backend_address_pool" "example" {
  name                = "example-backend-pool"
  loadbalancer_id     = azurerm_lb.example.id
}

# Health Probe ha for checking unhealthy vms
resource "azurerm_lb_probe" "example" {
  name                = "example-probe"
  loadbalancer_id     = azurerm_lb.example.id
  protocol            = "Tcp"
  port                = 80
  interval_in_seconds = 15
  number_of_probes    = 2
}

# traffic kesay front se backend
resource "azurerm_lb_rule" "example" {
  name                           = "example-rule"
  loadbalancer_id                = azurerm_lb.example.id
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.example.id]
  frontend_ip_configuration_name = azurerm_lb.example.frontend_ip_configuration[0].name
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  enable_tcp_reset               = true
  probe_id                       = azurerm_lb_probe.example.id
}

# private network bnaya ha backend vms kliye to isloate backend for safety , murtazas part
resource "azurerm_virtual_network" "example" {
  name                = "example-vnet"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  address_space       = ["10.0.0.0/16"]
}

# Subnet for the backend VM
resource "azurerm_subnet" "example" {
  name                 = "example-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Primary network interface for the VM
resource "azurerm_network_interface" "example" {
  name                = "primary-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Secondary network interface for failover
resource "azurerm_network_interface" "secondary" {
  name                = "secondary-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Availability set for VMs
resource "azurerm_availability_set" "example" {
  name                        = "example-aset"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  platform_fault_domain_count = 2
}

# Primary VM
resource "azurerm_linux_virtual_machine" "primary" {
  name                = "primary-backend-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  availability_set_id = azurerm_availability_set.example.id

  network_interface_ids = [
    azurerm_network_interface.example.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/DELL/.ssh/id_rsa.pub")  # Update with your SSH public key path
  }

  tags = {
    environment = "example"
  }
}

# Secondary VM for failover
resource "azurerm_linux_virtual_machine" "secondary" {
  name                = "secondary-backend-vm"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  size                = "Standard_B1s"
  admin_username      = "adminuser"
  availability_set_id = azurerm_availability_set.example.id

  network_interface_ids = [
    azurerm_network_interface.secondary.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("C:/Users/DELL/.ssh/id_rsa.pub")  # Update with your SSH public key path
  }

  tags = {
    environment = "example"
  }
}

# Add both VMs to the backend pool of Load Balancer
resource "azurerm_network_interface_backend_address_pool_association" "primary" {
  network_interface_id    = azurerm_network_interface.example.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}

resource "azurerm_network_interface_backend_address_pool_association" "secondary" {
  network_interface_id    = azurerm_network_interface.secondary.id
  ip_configuration_name   = "internal"
  backend_address_pool_id = azurerm_lb_backend_address_pool.example.id
}
