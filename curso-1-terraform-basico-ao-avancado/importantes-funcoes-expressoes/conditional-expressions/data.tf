data "local_file" "azure_credentials" {
  filename = "${path.module}/../../azure_credentials.json"
}
