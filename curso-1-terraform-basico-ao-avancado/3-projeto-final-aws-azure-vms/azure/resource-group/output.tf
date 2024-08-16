output "rg_name" {
  description = "Nome do Resource Group criado na Azure"
  value       = azurerm_resource_group.resource_group.name
}
