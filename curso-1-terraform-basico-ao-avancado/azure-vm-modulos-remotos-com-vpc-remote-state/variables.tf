variable "location" {
  description = "Região onde os recursos serão criados na azure"
  type        = string
  default     = "East US"
  nullable    = false
}

variable "environment" {
  description = "Ambiente a quem pertence os recursos criados na aws"
  type        = string
  default     = "DEV-ESTUDOS"
}
