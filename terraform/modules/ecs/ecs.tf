resource "aws_ecs_cluster" "this" {
  name = var.name

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_cluster_capacity_providers" "this" {
  cluster_name = aws_ecs_cluster.this.name

  capacity_providers = ["FARGATE_SPOT"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}

resource "aws_ecs_task_definition" "this" {
  count = var.frontend_docker_image != null || var.flask_api_docker_image != null ? 1 : 0

  family                   = var.name
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_task_cpu
  memory                   = var.ecs_task_memory

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = var.frontend_docker_image
      essential = true

      linuxParameters = {
        initProcessEnabled = true
      }

      portMappings = [
        {
          containerPort = var.alb_target_group_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "frontend"
        }
      },

      dependsOn = [
        {
          containerName = "flask-api"
          condition     = "START"
        }
      ],
    },
    {
      name      = "flask-api",
      image     = var.flask_api_docker_image,
      essential = true,

      linuxParameters = {
        initProcessEnabled = true
      }

      portMappings = [
        {
          containerPort = var.ecs_flask_api_port
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name,
          awslogs-region        = data.aws_region.current.name,
          awslogs-stream-prefix = "flask-api"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "this" {
  count = var.frontend_docker_image != null || var.flask_api_docker_image != null ? 1 : 0

  name                   = var.name
  cluster                = aws_ecs_cluster.this.id
  task_definition        = aws_ecs_task_definition.this[0].arn
  desired_count          = 1
  force_new_deployment   = true
  scheduling_strategy    = "REPLICA"
  enable_execute_command = true


  network_configuration {
    security_groups  = [aws_security_group.ecs.id]
    subnets          = var.subnets_id
    assign_public_ip = var.ecs_task_public_ip
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.this.arn
    container_name   = "frontend"
    container_port   = 80
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 1
  }
}
