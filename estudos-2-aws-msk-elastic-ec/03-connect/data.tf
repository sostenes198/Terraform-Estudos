# Lê o state do 01-msk a partir do arquivo local
data "terraform_remote_state" "msk" {
  backend = "local"
  config = {
    path = "${path.module}/../01-msk/terraform.tfstate"
  }
}


data "terraform_remote_state" "ess" {
  backend = "local"
  config = {
    path = "${path.module}/../02-elastic-ec/terraform.tfstate"
  }
}
