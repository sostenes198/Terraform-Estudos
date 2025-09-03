locals {
  default_tags = {
    ResourceGroup = "poc-msk",
    Project       = "poc-msk"
    ManagedBy     = "terraform"
  }


  vpc_cidr = "10.40.0.0/16"

  # seleciona as primeiras N AZs disponíveis
  azs_selected = slice(
    data.aws_availability_zones.available.names,
    0,
    min(var.azs_count, length(data.aws_availability_zones.available.names))
  )

  # /24 para cada AZ, faixas separadas para público e privado
  public_subnets  = [for i, _ in local.azs_selected : cidrsubnet(local.vpc_cidr, 8, i + 1)]
  private_subnets = [for i, _ in local.azs_selected : cidrsubnet(local.vpc_cidr, 8, 10 + (i + 1))]

  elastic_supported_az_names = toset(data.aws_vpc_endpoint_service.elastic.availability_zones)

  # Somente as subnets privadas em AZs suportadas
  eligible_private_subnet_ids = [
    for id, s in data.aws_subnet.private :
    id if contains(local.elastic_supported_az_names, s.availability_zone)
  ]
}
