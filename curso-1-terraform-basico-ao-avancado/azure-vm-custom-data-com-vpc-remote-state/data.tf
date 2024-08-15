data "local_file" "azure_credentials" {
  filename = "${path.module}/../azure_credentials.json"
}

data "local_file" "azure_remote_state" {
  filename = "${path.module}/../azure.remote.state.default.json"
}


data "terraform_remote_state" "remote_state" {
  backend = "azurerm"
  config = {
    resource_group_name  = local.remote_state.resourceGroupName
    storage_account_name = local.remote_state.storageAccountName
    container_name       = local.remote_state.containerName
    key                  = local.remote_state.keys.vnet
    client_id            = local.credentials.clientId
    client_secret        = local.credentials.clientSecret
    subscription_id      = local.credentials.subscriptionId
    tenant_id            = local.credentials.tenantId
  }
}