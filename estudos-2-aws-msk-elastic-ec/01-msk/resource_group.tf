resource "aws_resourcegroups_group" "poc" {
  name        = "rg-poc-msk"
  description = "Todos os recursos do projeto poc-msk"

  resource_query {
    type = "TAG_FILTERS_1_0"
    query = jsonencode({
      ResourceTypeFilters = ["AWS::AllSupported"]
      TagFilters = [{
        Key    = "ResourceGroup"
        Values = ["poc-msk"]
      }]
    })
  }

  # (opcional) tags no próprio grupo
  tags = {
    ResourceGroup = "poc-msk"
  }
}
