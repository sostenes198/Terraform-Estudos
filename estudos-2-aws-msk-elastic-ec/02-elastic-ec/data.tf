data "ec_stack" "v8" {
 # Pega a versão mais recente da família 8.x
  version_regex = "^8\\..*$"
  region        = var.ec_region
}

# data "ec_deployment_templates" "io" {
#   id            = "aws-io-optimized"
#   region        = var.ec_region
#   # stack_version = data.ec_stack.latest.version
# }

# (opcional) pegar outputs do 01-msk para usar o VPC Endpoint no traffic filter
data "terraform_remote_state" "msk" {
  backend = "local"
  config = {
    path = "${path.module}/../01-msk/terraform.tfstate"
  }
}