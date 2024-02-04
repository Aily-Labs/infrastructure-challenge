# Github OpenID

This module will create all the ECS infrastructure using Fargate Spot for the challenge.
When this module is applied, it should create the following resources:

## Usage

```hcl
module "ecs" {
  source = "../../backup/jefferson/infrastructure-challenge/terraform/modules/ecs"

  vpc_id = "vpc-000000000"
  subnets_id = [
    "subnet-111111111111",
    "subnet-222222222222"
  ]
  certificate_arn        = "arn:aws:acm:eu-east-1:00000000:certificate/aaaaaaaa-0000-1111-2222-bbbbbbbbbb"
  zone_name              = "test.com"
  frontend_docker_image  = "00000000.dkr.ecr.eu-east-1.amazonaws.com/frontend:1.0"
  flask_api_docker_image = "00000000.dkr.ecr.eu-east-1.amazonaws.com/flask-api:1.0"
    ecr_repositories_arn = [
    "arn:aws:ecr:eu-east-1:00000000:repository/flask-api",
    "arn:aws:ecr:eu-east-1:00000000:repository/frontend"
  ]
}
```
