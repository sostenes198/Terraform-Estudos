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
