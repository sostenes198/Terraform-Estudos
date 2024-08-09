resource "azurerm_resource_group" "resource_group" {
  name     = "rg-curso-terraform"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "sosoestudosterraform"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "container-terraform"
  storage_account_name  = azurerm_storage_account.storage_account.name
  container_access_type = "private"
}
