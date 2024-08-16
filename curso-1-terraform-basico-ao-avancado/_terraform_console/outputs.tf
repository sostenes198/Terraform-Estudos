output "rg_id" {
  description = "Id do Resource Group criado na azure"
  value       = azurerm_resource_group.resource_group.id
}
