variable "location" {
  description = "Região onde os recursos serão criados na azure"
  type        = string
  nullable    = false
}

variable "common_tags" {
  description = "Tags padrão a serem adicionadas ao recursos"
  type        = object({})
  nullable    = false
}

variable "ssh_file_name" {
  description = "Nome do arquivo de criptografia SSH"
  type        = string
  default     = "azure-key.pub"
  nullable    = false
}
