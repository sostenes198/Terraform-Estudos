terraform {
  required_version = ">= 2.7.0",
  required_providers {
    aws = {
        version = "1.0"
        source = "hashicorp/aws"
    }
    azurerm = {
        version = "1.0"
        source = "hashicorp/azurerm"
    }
  }

  backend "" {
    
  }
}