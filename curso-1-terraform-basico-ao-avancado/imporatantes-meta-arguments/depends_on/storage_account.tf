resource "azurerm_resource_group" "resource_group" {
  for_each = {
    "a_group"       = "eastus"
    "another_group" = "wetus2"
  }
  name     = each.key
  location = each.value
  tags     = local.common_tags
}

# resource "azurerm_storage_account" "storage_account" {

#   depends_on = [azurerm_resource_group.resource_group]

#   name                     = var.storage_account_name
#   resource_group_name      = azurerm_resource_group.resource_group.name
#   location                 = var.location
#   account_tier             = var.account_tier
#   account_replication_type = var.account_replication_type
#   count                    = 4
#   tags = merge(local.common_tags,
#     {
#       index = "${count.index}"
#     }
#   )
# }

# resource "azurerm_storage_container" "storage_container" {
#   name                 = var.storage_container_name
#   storage_account_name = azurerm_storage_account.storage_account.name
# }
