resource "aws_security_group" "connect_like" {
  # só pra permitir o teste com kcat no futuro (usaremos depois)
  name   = "secGroup-connect-like"
  vpc_id = module.vpc.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.default_tags
}

resource "aws_security_group" "msk" {
  name   = "secGroup-msk"
  vpc_id = module.vpc.vpc_id
  ingress {
    from_port       = 9094
    to_port         = 9094
    protocol        = "tcp"
    security_groups = [aws_security_group.connect_like.id]
    description     = "Kafka TLS from testing / connect"
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.default_tags
}


resource "aws_msk_configuration" "cluster_cfg" {
  name           = "poc-msk-config"
  kafka_versions = ["3.6.0"] # compatível com o seu cluster
  server_properties = <<-PROPS
    auto.create.topics.enable=true
    # (opcional) defaults úteis p/ POC:
    num.partitions=1
    default.replication.factor=2
    min.insync.replicas=2
    # delete.topic.enable=true
  PROPS
}

resource "aws_msk_cluster" "this" {
  cluster_name           = "poc-msk"
  kafka_version          = "3.6.0"

  # total de brokers = nº de AZs * brokers por AZ
  number_of_broker_nodes = length(local.azs_selected) * var.brokers_per_az

  broker_node_group_info {
    instance_type   = "kafka.m5.large"
    client_subnets  = module.vpc.private_subnets  # 1 subnet por AZ
    security_groups = [aws_security_group.msk.id]
  }

  encryption_info {
    encryption_in_transit {
      client_broker = "TLS"
      in_cluster    = true
    }
  }

  configuration_info {
    arn = aws_msk_configuration.cluster_cfg.arn
    revision = aws_msk_configuration.cluster_cfg.latest_revision
  }

  enhanced_monitoring = "DEFAULT"

  tags = local.default_tags
}