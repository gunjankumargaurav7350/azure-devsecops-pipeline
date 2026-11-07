output "resource_group_ids" {
  description = "Map of resource group IDs provisioned via for_each"
  value       = { for k, v in azurerm_resource_group.rg : k => v.id }
}

output "hub_vnet_id" {
  description = "Virtual Network resource ID"
  value       = azurerm_virtual_network.hub.id
}

output "subnet_ids" {
  description = "Map of provisioned subnet IDs"
  value       = { for k, v in azurerm_subnet.subnets : k => v.id }
}

output "key_vault_uri" {
  description = "Azure Key Vault Vault URI"
  value       = azurerm_key_vault.kv.vault_uri
}
