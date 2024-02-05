# Github OpenID

This module deploys everything needed to allow Github action push to ECR repositories.

## Usage

```hcl
module "github_openid" {
  source  = "./modules/github"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repositories_name | A list of string ARNs of the ECR repositories that GitHub will have permissions for | `list(string)` | `[]` | yes |

## Outputs

| Name | Description |
|------|-------------|
| github_identity_provider_arn | The ARN of the created identity provider |
| github_actions_role_arn | The ARN of the role created for GitHub OpenID |
| github_actions_role_name | The name of the role created for GitHub OpenID |
