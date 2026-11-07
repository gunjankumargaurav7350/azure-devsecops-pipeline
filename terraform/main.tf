# ------------------------------------------------------------------------------
# Resource Groups Provisioned with for_each
# ------------------------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  for_each = var.resource_groups

  name     = "rg-${var.environment}-${each.key}"
  location = each.value.location
  tags     = each.value.tags
}

# ------------------------------------------------------------------------------
# Hub Virtual Network
# ------------------------------------------------------------------------------
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-${var.environment}-hub"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg["network"].name
  address_space       = ["10.0.0.0/16"]

  tags = {
    Environment = var.environment
    ManagedBy   = "DevSecOps-Pipeline"
  }
}

# ------------------------------------------------------------------------------
# Subnets Provisioned using for_each
# ------------------------------------------------------------------------------
resource "azurerm_subnet" "subnets" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.rg["network"].name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = [each.value.cidr_block]
  service_endpoints    = each.value.service_endpoints
}

# ------------------------------------------------------------------------------
# Azure Key Vault (Enforcing CIS Controls & Zero Trust)
# ------------------------------------------------------------------------------
data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "kv-${var.environment}-sec01"
  location                    = var.location
  resource_group_name         = azurerm_resource_group.rg["security"].name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 90
  purge_protection_enabled    = true
  sku_name                    = "premium"

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }

  tags = {
    Environment = var.environment
    Compliance  = "CIS-Azure-Security"
  }
}
