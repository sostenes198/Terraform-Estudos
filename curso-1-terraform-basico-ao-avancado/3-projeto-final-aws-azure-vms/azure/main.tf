terraform {
  required_version = ">=1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.0.0"
    }

    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.48.0"
    }
  }
}


provider "azurerm" {
  client_id       = local.credentials.clientId
  client_secret   = local.credentials.clientSecret
  subscription_id = local.credentials.subscriptionId
  tenant_id       = local.credentials.tenantId

  features {
  }
}

module "resource_group" {
  source      = "./resource-group"
  common_tags = local.common_tags
  location    = var.location
}

module "network" {
  source      = "./network"
  common_tags = local.common_tags
  location    = var.location
}

module "vm" {
  source      = "./vm"
  common_tags = local.common_tags
  location    = var.location
}
