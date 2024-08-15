variable "cidr_vpc" {
  description = "Cidr para a VPC criada na aws"
  type        = string
}

variable "cidr_subnet" {
  description = "Cidr para a Subnet criada na aws"
  type        = string
}

variable "environment" {
  description = "Ambiente a quem pertence os recursos criados na aws"
  type        = string
}
