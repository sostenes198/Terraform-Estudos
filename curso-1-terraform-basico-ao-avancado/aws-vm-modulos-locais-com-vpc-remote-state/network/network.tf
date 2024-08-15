resource "aws_vpc" "aws_vpc" {
  cidr_block = var.cidr_vpc

  tags = {
    Name = "estudos-terraform-vpc-${var.environment}"
  }
}

resource "aws_subnet" "aws_subnet" {
  vpc_id     = aws_vpc.aws_vpc.id
  cidr_block = var.cidr_subnet

  tags = {
    Name = "estudos-terraform-subnet-${var.environment}"
  }
}

resource "aws_internet_gateway" "aws_internet_gateway" {
  vpc_id = aws_vpc.aws_vpc.id

  tags = {
    Name = "estudos-terraform-internet-gateway-${var.environment}"
  }
}

resource "aws_route_table" "aws_route_table" {
  vpc_id = aws_vpc.aws_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.aws_internet_gateway.id
  }

  tags = {
    Name = "estudos-terraform-route-table-${var.environment}"
  }
}

resource "aws_route_table_association" "aws_route_table_association" {
  subnet_id      = aws_subnet.aws_subnet.id
  route_table_id = aws_route_table.aws_route_table.id
}


resource "aws_security_group" "aws_security_group" {
  name        = "aws_security_group"
  description = "Allow access SSH"
  vpc_id      = aws_vpc.aws_vpc.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "estudos-terraform-security-group-${var.environment}"
  }
}
