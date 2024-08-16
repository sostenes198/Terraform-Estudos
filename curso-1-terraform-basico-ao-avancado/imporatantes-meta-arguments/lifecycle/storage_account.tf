resource "azurerm_resource_group" "resource_group" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags

  lifecycle {
    prevent_destroy = true # Previni que o recurso seja destruído
  }
}

resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type
  tags                     = local.common_tags

  lifecycle {
    create_before_destroy = true # cria a nova storage account antes de destruir a atual
    ignore_changes        = [tags] # ignora alterações de tags
    replace_triggered_by = [ azurerm_resource_group.resource_group ] # Altera esse recurso se o recurso de referência sofrer alteração
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                 = var.storage_container_name
  storage_account_name = azurerm_storage_account.storage_account.name
}
