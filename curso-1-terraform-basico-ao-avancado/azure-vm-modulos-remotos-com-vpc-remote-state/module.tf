module "network" {
  source              = "Azure/network/azurerm"
  version             = "5.2.0"
  resource_group_location = var.location
  resource_group_name = azurerm_resource_group.rg.name
  use_for_each        = true
  subnet_names        = ["subnet-${var.environment}"]
  vnet_name           = "vnet-${var.environment}"
  tags                = local.common_tags
}
