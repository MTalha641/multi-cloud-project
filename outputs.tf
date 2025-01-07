# Output the public IP of the Load Balancer
output "load_balancer_ip" {
  value = azurerm_public_ip.example.ip_address
}

# Output the frontend IP configuration ID
output "frontend_ip_configuration_id" {
  value = azurerm_lb.example.frontend_ip_configuration[0].id
}

# Output the Load Balancer's backend pool ID
output "backend_pool_id" {
  value = azurerm_lb_backend_address_pool.example.id
}
