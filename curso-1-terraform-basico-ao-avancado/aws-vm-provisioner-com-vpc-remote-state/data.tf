data "local_file" "aws_remote_state" {
  filename = "${path.module}/../aws.remote.state.default.json"
}


data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket                   = local.remote_state.bucket
    key                      = local.remote_state.keys.vpc
    region                   = local.remote_state.region
    shared_credentials_files = ["${path.module}/../aws_credentials"]
    profile                  = "estudosTerraform"
  }
}
