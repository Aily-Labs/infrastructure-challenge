resource "aws_security_group" "this_ecs" {
  name        = "${var.name}-ecs-task"
  description = "Grafana ECS task security group"
  vpc_id      = var.vpc_id

  ingress {
    protocol        = "tcp"
    from_port       = 80
    to_port         = 80
    security_groups = [module.alb.security_group_id]
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
