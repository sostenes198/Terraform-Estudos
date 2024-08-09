resource "azurerm_resource_group" "rg" {
  name     = "estudos-curso-terraform"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_storage_account" "stAcc" {
  name                     = "sosoestudosterraform"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.common_tags
  blob_properties {
    versioning_enabled = true
  }
}

resource "azurerm_storage_container" "storage_container" {
  name                  = "ssstcontestudos"
  storage_account_name  = azurerm_storage_account.stAcc.name
}
