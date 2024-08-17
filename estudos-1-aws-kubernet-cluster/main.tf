terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.4.3"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.16.1"
    }
  }
}

provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
}

provider "aws" {
  region                   = var.region
  shared_credentials_files = ["${path.module}/aws_credentials"]
  profile                  = "estudos"
  default_tags {
    tags = local.common_tags
  }
}
