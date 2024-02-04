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
