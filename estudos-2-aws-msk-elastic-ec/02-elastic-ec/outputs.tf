# Endpoints do Elasticsearch (HTTP/HTTPS)
output "ess_http_endpoint" {
  description = "Endpoint HTTP do Elasticsearch"
  value       = ec_deployment.ess.elasticsearch.http_endpoint
}

output "ess_https_endpoint" {
  description = "Endpoint HTTPS do Elasticsearch"
  value       = ec_deployment.ess.elasticsearch.https_endpoint
}

# alias do ESS (ex.: "my-deploy-abc123") extraído do endpoint público
output "ess_alias" {
  value = regex(
     "https://([^.]+)\\..*", # captura tudo entre https:// e o primeiro ponto,
    ec_deployment.ess.elasticsearch.https_endpoint,
  )[0]
}

# Kibana
output "kibana_https_endpoint" {
  description = "Endpoint HTTPS do Kibana"
  value       = ec_deployment.ess.kibana.https_endpoint
}

# Cloud ID (útil para Beats/Elastic Agent e libs que aceitam CloudID)
output "ess_cloud_id" {
  description = "Cloud ID do deployment"
  value       = ec_deployment.ess.elasticsearch.cloud_id
}

# Credenciais geradas pelo Elastic Cloud
output "ess_username" {
  description = "Usuário admin padrão do Elasticsearch"
  value       = ec_deployment.ess.elasticsearch_username
}

output "ess_password" {
  description = "Senha do usuário admin padrão do Elasticsearch"
  value       = ec_deployment.ess.elasticsearch_password
  sensitive   = true
}

# Infos úteis do deployment
output "ess_deployment_id" {
  description = "ID do deployment criado"
  value       = ec_deployment.ess.id
}

output "ess_region" {
  description = "Região configurada no provider"
  value       = ec_deployment.ess.region
}

output "ess_version" {
  description = "Versão da stack do Elasticsearch"
  value       = ec_deployment.ess.version
}

output "ess_deployment_template_id" {
  description = "Template de deployment utilizado"
  value       = ec_deployment.ess.deployment_template_id
}
