terraform {
  required_version = ">=1.3.0"

  required_providers {
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
