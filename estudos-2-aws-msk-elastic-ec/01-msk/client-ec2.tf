# Reaproveita o SG que você já criou para testes de Connect/kcat
# (no seu projeto ele se chama aws_security_group.connect_like)
resource "aws_instance" "client" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  subnet_id              = module.vpc.private_subnets[0]
  vpc_security_group_ids = [aws_security_group.connect_like.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_ssm_profile.name

  user_data = <<-EOF
        #!/bin/bash
        set -eux
        # SSM Agent (garante instalação e start)
        dnf install -y amazon-ssm-agent
        systemctl enable --now amazon-ssm-agent
        # Instala Docker para rodar kcat em container
        dnf update -y
        dnf install -y docker
        systemctl enable --now docker
        usermod -aG docker ssm-user
    EOF


  tags = local.default_tags
}
