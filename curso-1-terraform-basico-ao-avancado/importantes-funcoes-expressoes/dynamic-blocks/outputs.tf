output "subnet_id" {
  description = "ID da Subnet criada na AWS"
  value       = aws_subnet.aws_subnet.id
}

output "security_group_id" {
  description = "ID da Security Group criada na AWS"
  value       = aws_security_group.aws_security_group.id
}