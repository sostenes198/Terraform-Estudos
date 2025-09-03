variable "aws_region" {
  description = "Região onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

# Quantas AZs você quer usar (2 ou 3, tipicamente)
variable "azs_count" {
  type        = number
  default     = 2
  description = "Quantidade de AZs a usar (2 ou 3)"
}

# Brokers por AZ (1 por AZ para PoC = total brokers == azs_count)
variable "brokers_per_az" {
  type        = number
  default     = 1
  description = "Brokers por AZ (total = azs_count * brokers_per_az)"
}

variable "privatelink_service_name" {
  # pegue da doc da Elastic p/ SUA região
  type    = string
  default = "com.amazonaws.vpce.us-east-1.vpce-svc-0e42e1e06ed010238"
}

variable "privatelink_domain" {
  # domínio PrivateLink da Elastic na SUA região (ex.: us-east-1)
  type    = string
  default = "vpce.us-east-1.aws.elastic-cloud.com"
}

# IP público em CIDR (/32) para acessar do laptop
variable "my_ip" {
  type    = string
  default = "191.53.178.49/32"
}