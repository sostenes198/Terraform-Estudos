resource "aws_vpc" "aws_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "estudos-terraform-vpc-${terraform.workspace}"
  }
}

resource "aws_subnet" "aws_subnet" {
  count      = terraform.workspace == "prod" ? 3 : 1
  vpc_id     = aws_vpc.aws_vpc.id
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Name = "estudos-terraform-subnet-${terraform.workspace}-${count.index}"
  }
}
