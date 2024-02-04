resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.github.certificates[0].sha1_fingerprint]
}

resource "aws_iam_role" "github" {
  name               = "github-actions-aily-labs"
  assume_role_policy = data.aws_iam_policy_document.github_assume_role.json
}
