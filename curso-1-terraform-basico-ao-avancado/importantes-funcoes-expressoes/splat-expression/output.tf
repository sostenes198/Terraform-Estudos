output "subnets_id"{
    value = aws_subnet.subnet[*].id
}