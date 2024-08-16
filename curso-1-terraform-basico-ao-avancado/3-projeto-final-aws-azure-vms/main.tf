terraform {
  backend "azurerm" {}
}

module "aws" {
  source = "./aws"
}

module "azure" {
  source = "./azure"
}
