output "repositories_arn" {
  value = aws_ecr_repository.this[*].arn
}

output "repositories_url" {
  value = aws_ecr_repository.this[*].repository_url
}
