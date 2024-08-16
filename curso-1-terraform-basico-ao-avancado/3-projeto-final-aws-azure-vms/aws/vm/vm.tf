
resource "null_resource" "generate_ssh_key" {
  provisioner "local-exec" {
    when    = create
    command = "rm -f aws-key && rm -f aws-key.pub && ssh-keygen -t rsa -b 4096 -f aws-key -N \"\""
  }
}

resource "aws_key_pair" "key_pair" {
  depends_on = [null_resource.generate_ssh_key]
  key_name   = "aws-key"
  public_key = terraform_data.exist_ssh_file.input ? file("${path.module}/${var.ssh_file_name}") : file("${path.module}/default-key.pub")
}

resource "aws_instance" "vm" {
  ami                         = "ami-0e872aee57663ae2d"
  instance_type               = "t2.micro"
  key_name                    = aws_key_pair.key_pair.key_name
  subnet_id                   = module.network.network_subnet_id
  vpc_security_group_ids      = [module.network.network_security_group_id]
  associate_public_ip_address = true
  tags = {
    Name = "terraform-vm"
  }
}
