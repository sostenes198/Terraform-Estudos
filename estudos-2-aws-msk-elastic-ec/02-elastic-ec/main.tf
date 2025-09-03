terraform {
  required_providers {
    ec = { source = "elastic/ec", version = "~> 0.10" }
  }
}

provider "ec" {
  # Gere uma Organization API Key no console do Elastic Cloud
  apikey = local.elastic_credentials
}