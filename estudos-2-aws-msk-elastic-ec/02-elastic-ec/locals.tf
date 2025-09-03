locals {
  elastic_credentials = "${trimspace(file("${path.module}/elastic_credentials"))}"

  vpc_id = data.terraform_remote_state.msk.outputs.vpce_id

  my_ip = data.terraform_remote_state.msk.outputs.my_ip
}