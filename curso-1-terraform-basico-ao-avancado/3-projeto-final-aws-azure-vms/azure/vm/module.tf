module "resource_group" {
  source      = "../resource-group"
  common_tags = var.common_tags
  location    = var.location
}


module "network" {
  source      = "../network"
  common_tags = var.common_tags
  location    = var.location
}
