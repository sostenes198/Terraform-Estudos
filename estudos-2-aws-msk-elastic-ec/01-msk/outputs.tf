# MSK (você já deve ter algo assim)
output "msk_bootstrap_brokers_tls" {
  description = "Bootstrap brokers (TLS) do cluster MSK"
  value       = aws_msk_cluster.this.bootstrap_brokers_tls
}

# EC2 cliente — InstanceId
output "ec2_client_instance_id" {
  description = "Instance ID da EC2 cliente (para usar no SSM)"
  value       = aws_instance.client.id
}

# (Opcional) Comando pronto do SSM
output "ec2_client_ssm_command" {
  description = "Comando para abrir sessão SSM na EC2 cliente"
  value       = "aws ssm start-session --target ${aws_instance.client.id} --profile poc-mks"
}

# (Opcional) IP privado — útil para troubleshooting
output "ec2_client_private_ip" {
  description = "IP privado da EC2 cliente"
  value       = aws_instance.client.private_ip
}

output "private_subnet_ids" {
  value       = module.vpc.private_subnets
  description = "Subnets privadas para rodar o MSK Connect"
}

output "aws_security_group_connect_like_id" {
  value = aws_security_group.connect_like.id
}

output "aws_security_group_msk_id" {
  value = aws_security_group.msk.id
}


############################################
# Infos do serviço PrivateLink (Elastic)
############################################

# Nome do serviço (o que você passou em var)
output "privatelink_service_name" {
  description = "Service name do PrivateLink do Elastic (fornecido pela UI)"
  value       = var.privatelink_service_name
}

# AZs suportadas pelo serviço (nomes, ex.: us-east-1a)
output "privatelink_supported_az_names" {
  description = "Availability Zones suportadas pelo serviço PrivateLink do Elastic"
  value       = try(data.aws_vpc_endpoint_service.elastic.availability_zones, [])
}

# Subnets privadas elegíveis (filtradas pelas AZs suportadas)
output "privatelink_eligible_private_subnet_ids" {
  description = "Subnets privadas do VPC onde o VPC Endpoint pode ser criado (AZs suportadas)"
  value       = try(local.eligible_private_subnet_ids, [])
}

############################################
# VPC Endpoint (Interface)
############################################

output "vpce_id" {
  description = "ID do VPC Endpoint (Interface) criado para o Elastic"
  value       = try(aws_vpc_endpoint.elastic_privatelink.id, null)
}

output "vpce_state" {
  description = "Estado do VPC Endpoint"
  value       = try(aws_vpc_endpoint.elastic_privatelink.state, null)
}

# Um DNS por AZ do endpoint (úteis para testar/usar direto)
output "vpce_dns_names" {
  description = "Lista de DNS names do VPC Endpoint (um por AZ)"
  value       = try(aws_vpc_endpoint.elastic_privatelink.dns_entry[*].dns_name, [])
}

# Hosted Zone IDs correspondentes (se for criar registros por AZ)
output "vpce_dns_zone_ids" {
  description = "Hosted zone IDs dos DNS do VPC Endpoint (um por AZ)"
  value       = try(aws_vpc_endpoint.elastic_privatelink.dns_entry[*].hosted_zone_id, [])
}

output "vpce_network_interface_ids" {
  description = "ENIs criados para o VPC Endpoint (um por AZ)"
  value       = try(aws_vpc_endpoint.elastic_privatelink.network_interface_ids, [])
}

output "vpce_subnet_ids" {
  description = "Subnets onde o VPC Endpoint foi criado"
  value       = try(aws_vpc_endpoint.elastic_privatelink.subnet_ids, [])
}

# SG aplicado ao endpoint
output "vpce_security_group_id" {
  description = "Security Group anexado ao VPC Endpoint"
  value       = try(aws_security_group.privatelink.id, null)
}

############################################
# Route53 (DNS interno opcional)
############################################

output "privatelink_zone_name" {
  description = "Nome da Private Hosted Zone usada para resolver o PrivateLink"
  value       = try(aws_route53_zone.ess_vpce.name, null)
}

output "privatelink_zone_id" {
  description = "ID da Private Hosted Zone usada para resolver o PrivateLink"
  value       = try(aws_route53_zone.ess_vpce.zone_id, null)
}

output "privatelink_record_fqdn" {
  description = "FQDN do CNAME criado para o endpoint (se aplicável)"
  value       = try(aws_route53_record.ess_cname.fqdn, null)

}


output "my_ip" {
  description = "IP público em CIDR (/32) para acessar do laptop"
  value       = var.my_ip
}


############################################
# KAFKA
############################################
output "kafka_ui_alb_dns" {
  description = "DNS público do ALB (Kafka UI em HTTP)"
  value       = aws_lb.kui.dns_name
}
output "kafka_ui_url" {
  description = "URL do Kafka UI (HTTP)"
  value       = "http://${aws_lb.kui.dns_name}/"
}