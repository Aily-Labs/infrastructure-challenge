# Github OpenID

This module creates repositories in ECR based on the list of names provided in `repositories_name`. 
All repositories come with a lifecycle policy to remove untagged images.

## Usage

```hcl
module "ecr" {
  source = "./modules/ecr"

  repositories_name = [
    "flask-api",
    "frontend"
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| repositories_name | A list of strings with the names of the ECR repositories that will be created | `list(string)` | `[]` | yes |
| image_tag_mutability | The tag mutability setting for each repository | `string` | `MUTABLE` | no |
| scan_on_push | Indicates whether images are scanned after being pushed to the repository | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| repositories_arn | A list with the ARN of the created ECR repositories |
| repositories_url | A list with the URL of the created ECR repositories |
