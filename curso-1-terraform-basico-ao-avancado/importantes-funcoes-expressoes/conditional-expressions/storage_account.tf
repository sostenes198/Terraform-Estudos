resource "azurerm_resource_group" "resource_group" {
  name     = "${var.resource_group_name}-${var.environment}"
  location = var.location
  tags     = merge(local.common_tags, { environment = "${var.environment}" })
}

resource "azurerm_storage_account" "storage_account" {
  count                    = var.environment == "dev" ? 0 : 1
  name                     = "sosoestudosterraform"
  resource_group_name      = azurerm_resource_group.resource_group.name
  location                 = var.location
  account_tier             = var.environment == "prod" ? "Premium" : "Standard"
  account_replication_type = var.environment == "prod" ? "RAGZRS" : "LRS"
  tags                     = merge(local.common_tags, { environment = "${var.environment}" })
}
