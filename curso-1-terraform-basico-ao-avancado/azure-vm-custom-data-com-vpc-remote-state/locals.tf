locals {
  credentials  = jsondecode(data.local_file.azure_credentials.content)
  remote_state = jsondecode(data.local_file.azure_remote_state.content)
  common_tags = {
    owner     = "Soso",
    manage-by = "terraform"
  }
}
