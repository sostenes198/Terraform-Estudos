resource "azurerm_resource_group" "resource_group" {
  name     = "rg-projeto-final"
  location = var.location
  tags     = var.common_tags
}