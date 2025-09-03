# IAM p/ MSK Connect
resource "aws_iam_role" "connect" {
  name = "poc-msk-connect-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17", Statement = [{
      Effect = "Allow", Principal = { Service = "kafkaconnect.amazonaws.com" }, Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_policy" "connect" {
  name = "poc-msk-connect-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      { Effect = "Allow", Action = ["s3:GetObject", "s3:ListBucket"], Resource = [aws_s3_bucket.plugins.arn, "${aws_s3_bucket.plugins.arn}/*"] },
      { Effect = "Allow", Action = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents", "logs:DescribeLogStreams"], Resource = "*" },
      { Effect = "Allow", Action = ["ec2:CreateNetworkInterface", "ec2:DescribeNetworkInterfaces", "ec2:DeleteNetworkInterface", "ec2:DescribeSubnets", "ec2:DescribeSecurityGroups", "ec2:DescribeVpcs"], Resource = "*" }
    ]
  })
}
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.connect.name
  policy_arn = aws_iam_policy.connect.arn
}

resource "aws_cloudwatch_log_group" "msk_connect" {
  name              = "/aws/msk-connect/poc"
  retention_in_days = 3
}

# Worker config
resource "aws_mskconnect_worker_configuration" "wc" {
  name                    = "poc-worker-config"
  properties_file_content = <<-EOT
    # Requisitos mínimos do MSK Connect
    key.converter=org.apache.kafka.connect.storage.StringConverter
    value.converter=org.apache.kafka.connect.json.JsonConverter
    value.converter.schemas.enable=false

    # Ajuste inofensivo
    offset.flush.interval.ms=60000
  EOT
}

# Plugin (ZIP no S3)
resource "aws_mskconnect_custom_plugin" "es" {
  name         = "es-sink-plugin"
  content_type = "ZIP"
  location {
    s3 {
      bucket_arn = aws_s3_bucket.plugins.arn
      file_key   = aws_s3_object.es_sink_zip.key
    }
  }
}

resource "aws_mskconnect_connector" "sink" {
  name                       = "poc-es-sink"
  kafkaconnect_version       = "3.7.x"
  service_execution_role_arn = aws_iam_role.connect.arn

  depends_on = [
    aws_cloudwatch_log_group.msk_connect,
    aws_mskconnect_custom_plugin.es
  ]

  # timeouts { create = "10m" }  # opcional, dá mais fôlego se estiver lento

  capacity {
    provisioned_capacity {
      mcu_count    = 1
      worker_count = 1
    }
  }

  worker_configuration {
    arn      = aws_mskconnect_worker_configuration.wc.arn
    revision = aws_mskconnect_worker_configuration.wc.latest_revision
  }

  kafka_cluster {
    apache_kafka_cluster {
      bootstrap_servers = local.msk_bootstrap_brokers_tls # ex.: "b-1....:9094,b-2....:9094"
      vpc {
        subnets = local.msk_private_subnet_ids # ["subnet-aaa","subnet-bbb"]
        security_groups = [
          local.msk_aws_security_group_connect_like_id
        ]
      }
    }
  }

  # OBRIGATÓRIOS no provider atual:
  kafka_cluster_client_authentication {
    # Para MSK sem SASL/IAM (apenas TLS), use NONE
    authentication_type = "NONE" # ou "IAM" / "SASL_SCRAM" conforme seu cluster
  }

  kafka_cluster_encryption_in_transit {
    encryption_type = "TLS" # MSK TLS
  }

  # É 'plugin' (singular)
  plugin {
    custom_plugin {
      arn      = aws_mskconnect_custom_plugin.es.arn
      revision = aws_mskconnect_custom_plugin.es.latest_revision
    }
  }

  log_delivery {
    worker_log_delivery {
      cloudwatch_logs {
        enabled   = true
        log_group = "/aws/msk-connect/poc"
      }
    }
  }

  # MAPA de configs do conector
  connector_configuration = {
    "connector.class" = "io.confluent.connect.elasticsearch.ElasticsearchSinkConnector"
    "tasks.max"       = "2"

    # Tópicos dinâmicos
    "topics.regex" = "^(logs|pay|metrics)-.*"

    # Converters (ajuste se usar Avro/Schema Registry)
    "key.converter"                  = "org.apache.kafka.connect.storage.StringConverter"
    "value.converter"                = "org.apache.kafka.connect.json.JsonConverter"
    "value.converter.schemas.enable" = "false"

    # ESS via PrivateLink (troque pelas suas vars/valores)
    "connection.url"      = "https://${local.ess_alias}.${local.privatelink_domain}:443"
    "connection.username" = local.ess_user
    "connection.password" = local.ess_password

    # CRÍTICO para JSON sem schema:
    "schema.ignore" = "true"
    "key.ignore"    = "true"

    # DLQ + SMTs de roteamento
    "errors.tolerance"                                = "all"
    "errors.deadletterqueue.topic.name"               = "_dlq.ess.sink"
    "errors.deadletterqueue.topic.replication.factor" = "2"
    "errors.deadletterqueue.context.headers.enable"   = "true"

    # (sem transforms)
    # "transforms"                       = "route,date"
    # "transforms.route.type"            = "org.apache.kafka.connect.transforms.RegexRouter"
    # "transforms.route.regex"           = "^(.*)$"
    # "transforms.route.replacement"     = "kafka-$1"
    # "transforms.date.type"             = "org.apache.kafka.connect.transforms.TimestampRouter"
    # "transforms.date.timestamp.format" = "yyyy.MM.dd"
    # "transforms.date.topic.format"     = "$${topic}-$${timestamp}"
    # "transforms": "Mask,Flatten",
    # "transforms.Mask.type": "org.apache.kafka.connect.transforms.MaskField$Value",
    # "transforms.Mask.fields": "ssn,creditCard",
    # "transforms.Flatten.type": "org.apache.kafka.connect.transforms.Flatten$Value",
    # "transforms.Flatten.delimiter": "_"

    # Escrita
    "write.method" = "insert" # "upsert" só se você tiver chave/PK

    # Lote / performance (opcional)
    # "batch.size"              = "2000"
    # "max.in.flight.requests"  = "5"
    # "max.buffered.records"    = "20000"
  }
}
