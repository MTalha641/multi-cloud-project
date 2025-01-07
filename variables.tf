# Azure Provider Credentials
variable "azure_subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID"
  type        = string
}

variable "azure_client_id" {
  description = "Azure Client ID (Service Principal)"
  type        = string
}

variable "azure_client_secret" {
  description = "Azure Client Secret"
  type        = string
  sensitive   = true
}

variable "azure_region" {
  description = "Azure Region"
  type        = string
  default     = "westus"
}

variable "azure_resource_group" {
  description = "Azure Resource Group"
  type        = string
  default     = "example-resource-group"
}

# Project Configuration
variable "project_name" {
  description = "Base name for all resources"
  type        = string
  default     = "Multi-cloud-project"
}

# Network Configuration
variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Address prefix for the subnet"
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

# Output Variables
output "azure_region" {
  description = "The Azure region being used"
  value       = var.azure_region
}

output "azure_resource_group" {
  description = "The Azure Resource Group"
  value       = var.azure_resource_group
}
