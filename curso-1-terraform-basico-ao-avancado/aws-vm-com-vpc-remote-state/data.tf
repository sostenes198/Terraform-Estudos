data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket                   = "soso-rm-state-bucket"
    key                      = "aws-vpc/terraform.tfstate"
    region                   = "eu-central-1"
    shared_credentials_files = ["${path.module}/../aws_credentials"]
    profile                  = "estudosTerraform"
  }
}