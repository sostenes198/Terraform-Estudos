variable "defaultResourceName" {
  description = "Prefixo dos nomes de recursos da AWS"
  type        = string
  nullable    = false
}

variable "ssh_file_name" {
  description = "Nome do arquivo de criptografia SSH"
  type        = string
  default     = "aws-key.pub"
  nullable    = false
}