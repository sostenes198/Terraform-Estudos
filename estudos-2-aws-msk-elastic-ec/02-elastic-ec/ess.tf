resource "ec_deployment" "ess" {
  name                   = "poc-ess"
  region                 = var.ec_region
  version                = data.ec_stack.v8.version
  deployment_template_id = "aws-general-purpose"

  lifecycle {
    create_before_destroy = true # garante criar o v8 antes de destruir o antigo (se estiver no mesmo TF)
  }


  elasticsearch = {
    hot = {
      size        = "1g"
      zone_count  = 1
      autoscaling = {}
    }
  }

  kibana = {
    topology = {}
  }
}

########## traffic filter (Private connection) ##########
# Usa o VPC Endpoint que você já criou: aws_vpc_endpoint.elastic_privatelink.id
resource "ec_deployment_traffic_filter" "privatelink" {
  name   = "plink-${var.ec_region}"
  region = var.ec_region # ex.: "us-east-1"
  type   = "vpce"        # tipo para PrivateLink

  # uma regra por VPCE (se tiver mais de um, repita rule { ... })
  rule {
    source = local.vpc_id # ex.: "vpce-0d4a684b5a0b872d8" OBTER do 01-msk terraform output vpce_id
  }
}

# associa o filter ao seu deployment Elastic
# (ajuste "ec_deployment.ess" se o seu recurso tiver outro nome)
resource "ec_deployment_traffic_filter_association" "attach" {
  deployment_id     = ec_deployment.ess.id
  traffic_filter_id = ec_deployment_traffic_filter.privatelink.id
}

resource "ec_deployment_traffic_filter" "admin_ip" {
  name   = "admin-ip-${var.ec_region}"
  region = var.ec_region
  type   = "ip"

  rule {
    source = local.my_ip
  }
}

resource "ec_deployment_traffic_filter_association" "attach_admin_ip" {
  deployment_id     = ec_deployment.ess.id
  traffic_filter_id = ec_deployment_traffic_filter.admin_ip.id
}
