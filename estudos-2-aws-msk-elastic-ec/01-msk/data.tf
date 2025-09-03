data "aws_availability_zones" "available" {
  state = "available"
}
# e então usar as 2 ou 3 primeiras: slice(data.aws_availability_zones.available.names, 0, 3)

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["137112412989"] # Amazon
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

# Serviço PrivateLink (o name vem do Elastic Cloud UI para sua região)
data "aws_vpc_endpoint_service" "elastic" {
    service_name = var.privatelink_service_name
    service_type = "Interface"
}

data "aws_subnet" "private" {
  for_each = toset(module.vpc.private_subnets)
  id       = each.key
}