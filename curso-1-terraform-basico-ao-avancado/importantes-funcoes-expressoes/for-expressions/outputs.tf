output "storage_account_id" {
  value = [for sa in azurerm_storage_account.storage_account : sa.id] # Gerando uma lista
}

output "sa_primary_access_keys" {
  value     = { for key, sa in azurerm_storage_account.storage_account : key => sa.primary_access_key } # Gerando um objeto
  sensitive = true
}
