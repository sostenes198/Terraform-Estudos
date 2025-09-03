terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws",
      version = "~> 5.60",
    }
  }
}

provider "aws" {
  region                   = var.aws_region
  shared_credentials_files = ["${path.module}/aws_credentials"]
  profile                  = "poc-mks"

  default_tags {
    tags = local.default_tags
  }
}
