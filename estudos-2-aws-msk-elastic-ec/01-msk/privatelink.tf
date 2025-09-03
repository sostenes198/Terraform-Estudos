resource "aws_security_group" "privatelink" {
  name        = "secGroup-ess-privatelink"
  description = "SG para o VPC Endpoint (Elastic PrivateLink)"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block] # ou restrinja a SGs específicos das apps
  }

  ingress {
    from_port   = 9243
    to_port     = 9243
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block] # ou restrinja a SGs específicos das apps
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.default_tags
}

resource "aws_vpc_endpoint" "elastic_privatelink" {
  vpc_id            = module.vpc.vpc_id
  service_name      = var.privatelink_service_name
  vpc_endpoint_type = "Interface"

  subnet_ids = local.eligible_private_subnet_ids
  security_group_ids = [
    aws_security_group.privatelink.id,
    aws_security_group.connect_like.id,
    aws_security_group.msk.id
  ]

  private_dns_enabled = false

  lifecycle {
    precondition {
      condition     = length(local.eligible_private_subnet_ids) > 0
      error_message = "Nenhuma subnet privada do VPC está em AZ suportada pelo serviço PrivateLink do Elastic."
    }
  }


  tags = local.default_tags
}
