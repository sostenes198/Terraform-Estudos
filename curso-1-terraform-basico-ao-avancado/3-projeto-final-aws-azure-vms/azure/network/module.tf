module "resource_group" {
  source      = "../resource-group"
  common_tags = var.common_tags
  location    = var.location
}