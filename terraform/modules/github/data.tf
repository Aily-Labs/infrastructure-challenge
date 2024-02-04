data "aws_region" "current" {}

data "aws_iam_account_alias" "current" {}

data "tls_certificate" "github" {
  url = "https://token.actions.githubusercontent.com/.well-known/openid-configuration"
}

data "aws_iam_policy_document" "github_assume_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type = "Federated"
      identifiers = [
        data.aws_iam_openid_connect_provider.github_openid.arn
      ]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:Aily-Labs/infrastructure-challenge:ref:refs/heads/main",
        "repo:Aily-Labs/infrastructure-challenge:pull_request"
      ]
    }
  }
}
