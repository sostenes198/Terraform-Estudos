resource "aws_iam_role" "ecs_exec" {
  name = "ecsTaskExecutionRole-kafka-ui"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sts:AssumeRole"
    }]
  })
  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "ecs_exec_attach" {
  role       = aws_iam_role.ecs_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_security_group" "kui_alb" {
  name   = "secGroup-kafka-ui-alb"
  vpc_id = module.vpc.vpc_id

  ingress {
    description = "HTTP from my IP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.default_tags
}

resource "aws_security_group" "kui_task" {
  name   = "secGroup-kafka-ui-task"
  vpc_id = module.vpc.vpc_id

  ingress {
    description     = "From ALB on 8080"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.kui_alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.default_tags
}

resource "aws_security_group_rule" "msk_from_kui_ingress" {
  description              = "Kafka TLS from Kafka-UI task (ingress)"
  type                     = "ingress"
  from_port                = 9094
  to_port                  = 9094
  protocol                 = "tcp"
  security_group_id        = aws_security_group.msk.id      # SG dos brokers
  source_security_group_id = aws_security_group.kui_task.id # SG da task  
}

resource "aws_lb" "kui" {
  name               = "alb-kafka-ui"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.kui_alb.id]
  subnets            = module.vpc.public_subnets
  tags               = local.default_tags
}

resource "aws_lb_target_group" "kui" {
  name        = "tg-kafka-ui"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    enabled  = true
    path     = "/actuator/health"
    port     = "8080"
    protocol = "HTTP"
    matcher  = "200-399"
  }

  tags = local.default_tags
}

resource "aws_lb_listener" "kui_http" {
  load_balancer_arn = aws_lb.kui.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.kui.arn
  }
}

resource "aws_ecs_cluster" "kui" {
  name = "ecs-kafka-ui"
  tags = local.default_tags
}

resource "aws_cloudwatch_log_group" "kui" {
  name              = "/ecs/kafka-ui"
  retention_in_days = 3
  tags              = local.default_tags
}

resource "aws_ecs_task_definition" "kui" {
  family                   = "kafka-ui"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_exec.arn

  depends_on = [
    aws_msk_cluster.this
  ]

  container_definitions = jsonencode([
    {
      "name" : "kafka-ui",
      "image" : "provectuslabs/kafka-ui:latest",
      "essential" : true,
      "portMappings" : [
        { "containerPort" : 8080, "hostPort" : 8080, "protocol" : "tcp" }
      ],
      "environment" : [
        { "name" : "SERVER_PORT", "value" : "8080" },

        { "name" : "KAFKA_CLUSTERS_0_NAME", "value" : aws_msk_cluster.this.cluster_name },
        { "name" : "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS", "value" : aws_msk_cluster.this.bootstrap_brokers_tls },

        { "name" : "KAFKA_CLUSTERS_0_PROPERTIES_SECURITY_PROTOCOL", "value" : "SSL" },

        # use lowercase:
        { "name" : "KAFKA_CLUSTERS_0_PROPERTIES_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM", "value" : "https" },

        # (apenas para TESTE, se ainda der timeout, desabilite hostname verification temporariamente:)
        { "name": "KAFKA_CLUSTERS_0_PROPERTIES_SSL_ENDPOINT_IDENTIFICATION_ALGORITHM", "value": "" }
      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-region" : "${var.aws_region}",
          "awslogs-group" : "/ecs/kafka-ui",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])

  tags = local.default_tags
}

resource "aws_ecs_service" "kui" {
  name                   = "svc-kafka-ui"
  cluster                = aws_ecs_cluster.kui.id
  task_definition        = aws_ecs_task_definition.kui.arn
  desired_count          = 1
  launch_type            = "FARGATE"
  enable_execute_command = false

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.kui_task.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.kui.arn
    container_name   = "kafka-ui" # mesmo "name" da task definition
    container_port   = 8080       # mesma porta do container
  }

  depends_on = [
    aws_lb_listener.kui_http,
    aws_security_group_rule.msk_from_kui_ingress
  ]

  tags = local.default_tags
}
