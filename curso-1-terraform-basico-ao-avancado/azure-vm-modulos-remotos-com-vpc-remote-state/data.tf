data "local_file" "azure_credentials" {
  filename = "${path.module}/../azure_credentials.json"
}

data "local_file" "azure_remote_state" {
  filename = "${path.module}/../azure.remote.state.default.json"
}