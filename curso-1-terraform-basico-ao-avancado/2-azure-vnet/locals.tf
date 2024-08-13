locals {
  credentials = jsondecode(data.local_file.azure_credentials.content)
  common_tags = {
    owner     = "Soso",
    manage-by = "terraform"
  }
}
