output "subnet_id" {
  description = "Id da Subnet criada na azure"
  value       = azurerm_subnet.subnet.id
}

output "security_group_id" {
  description = "Id da Network Security Group criada na azure"
  value       = azurerm_network_security_group.nsg.id
}
