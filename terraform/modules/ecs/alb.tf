module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "9.5.0"

  name                       = "infrastructure"
  enable_deletion_protection = var.alb_deletion_protection
  vpc_id                     = var.vpc_id
  subnets                    = var.subnets_id

  # Security Group
  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "HTTP web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "HTTPS web traffic"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
    ex-https = {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.certificate_arn

      forward = {
        target_group_key = "infrastructure-public"
      }
    }
  }

  target_groups = {
    infrastructure-public = {
      name_prefix       = "infra"
      protocol          = "HTTP"
      port              = 3000
      target_type       = "ip"
      create_attachment = false
    }
  }
}
