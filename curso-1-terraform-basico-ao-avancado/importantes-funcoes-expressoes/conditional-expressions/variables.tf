variable "location" {
  description = "Região onde os recursos serão criados na azure"
  type        = string
  default     = "East US"
  nullable    = false
}

variable "environment" {
  description = "Defini qual ambiente o recurso será criado"
  type        = string
}

variable "resource_group_name" {
  description = "Nome para o Resource Group na Azure"
  type        = string
  default     = "rg-curso-terraform"
}
