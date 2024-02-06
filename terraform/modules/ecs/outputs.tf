output "alb_dns_name" {
  value = aws_lb.this.dns_name
}

output "alb_arn" {
  value = aws_lb.this.arn
}

output "alb_target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "alb_target_group_name" {
  value = aws_lb_target_group.this.name
}

output "alb_security_group_id" {
  value = aws_security_group.alb.id
}

output "ecs_task_security_group_id" {
  value = aws_security_group.ecs.id
}

output "ecs_cluster_name" {
  value = aws_ecs_cluster.this.name
}

output "ecs_cluster_arn" {
  value = aws_ecs_cluster.this.arn
}

output "ecs_task_definition_arn" {
  value = aws_ecs_task_definition.this[*].arn
}

output "ecs_task_definition_revision" {
  value = aws_ecs_task_definition.this[*].revision
}

output "ecs_service_name" {
  value = aws_ecs_service.this[*].name
}

output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "ecs_task_role_arn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "dns_name" {
  value = aws_route53_record.this[*].fqdn
}
