resource "aws_security_group" "alb" {
  name        = "${var.name}-alb"
  description = "Infrastructure ALB security group"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "https" {
  count = var.alb_https_expose == true ? 1 : 0

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb.id
}

resource "aws_security_group" "ecs" {
  name        = "${var.name}-ecs-task"
  description = "Infrastructure ECS task security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = var.alb_target_group_port
    to_port         = var.alb_target_group_port
    security_groups = [aws_security_group.alb.id]
    description     = "Allow access from ${var.name} application load balancer"
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Egress rule"
  }

  tags = {
    Name = "${var.name}-ecs-task"
  }
}
