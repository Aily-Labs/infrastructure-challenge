output "github_identity_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "github_actions_role_arn" {
  value = aws_iam_role.github.arn
}

output "github_actions_role_name" {
  value = aws_iam_role.github.name
}
