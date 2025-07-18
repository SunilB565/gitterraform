resource "aws_ecs_cluster" "main" {
  name = "fargate-cluster-${var.env}"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.env}-app"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.env}-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name  = "app1"
      image = var.app1_image
      portMappings = [{ containerPort = 3000 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "app1"
        }
      }
    },
    {
      name  = "app2"
      image = var.app2_image
      portMappings = [{ containerPort = 2000 }]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "app2"
        }
      }
    }
  ])
}

resource "aws_lb" "app" {
  name               = "${var.env}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnet_ids
  security_groups    = [var.lb_sg_id]
}

resource "aws_lb_target_group" "ecs_tg" {
  name        = "${var.env}-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  health_check {
    path     = "/"
    protocol = "HTTP"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"
  default_action { 
    type = "forward"
    target_group_arn = aws_lb_target_group.ecs_tg.arn 
  }
}

resource "aws_ecs_service" "app" {
  name            = "${var.env}-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1

  network_configuration {
    subnets         = var.public_subnet_ids
    security_groups = [var.service_sg_id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_tg.arn
    container_name   = "app1"
    container_port   = 3000
  }

  depends_on = [aws_lb_listener.http]
}

