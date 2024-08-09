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

provider "aws" {
  region                   = "eu-central-1"
  shared_credentials_files = ["${path.module}/../aws_credentials"]
  profile                  = "estudosTerraform"
  default_tags {
    tags = {
      owner     = "Sóstenes"
      manage-by = "terraform"
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
