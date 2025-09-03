locals {
  default_tags = {
    ResourceGroup = "poc-msk",
    Project       = "poc-msk"
    ManagedBy     = "terraform"
  }

  plugin_zip_path = "${path.module}/confluentinc-kafka-connect-elasticsearch-15.0.1.zip"

  privatelink_domain = "vpce.us-east-1.aws.elastic-cloud.com"

  ess_alias = data.terraform_remote_state.ess.outputs.ess_alias
  ess_user = data.terraform_remote_state.ess.outputs.ess_username
  ess_password = data.terraform_remote_state.ess.outputs.ess_password

  msk_bootstrap_brokers_tls = data.terraform_remote_state.msk.outputs.msk_bootstrap_brokers_tls
  msk_private_subnet_ids = data.terraform_remote_state.msk.outputs.private_subnet_ids
  msk_aws_security_group_connect_like_id = data.terraform_remote_state.msk.outputs.aws_security_group_connect_like_id  
}
