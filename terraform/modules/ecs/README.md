# Github OpenID

This module will create all the ECS infrastructure using Fargate Spot for the challenge.

## Usage

In this first example, we are creating all the necessary resources for the challenge except for the tasks because we haven't created our images yet.

```hcl
module "ecr" {
  source = "./modules/ecr"

  repositories_name = [
    "flask-api",
    "frontend"
  ]
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id = "vpc-000000000"
  subnets_id = [
    "subnet-111111111111",
    "subnet-222222222222"
  ]

  alb_https_expose       = false
  zone_name              = "test.com"
  ecr_repositories_arn = module.ecr.repositories_arn
}
```

In the second example, we will add our already created Docker images, and as a result, the tasks will be created in our cluster.

```hcl
module "ecr" {
  source = "./modules/ecr"

  repositories_name = [
    "flask-api",
    "frontend"
  ]
}

module "ecs" {
  source = "./modules/ecs"

  vpc_id = "vpc-000000000"
  subnets_id = [
    "subnet-111111111111",
    "subnet-222222222222"
  ]

  alb_https_expose       = false
  zone_name              = "test.com"
  frontend_docker_image  = "00000000.dkr.ecr.eu-east-1.amazonaws.com/frontend:1.0"
  flask_api_docker_image = "00000000.dkr.ecr.eu-east-1.amazonaws.com/flask-api:1.0"
  ecr_repositories_arn = module.ecr.repositories_arn
}
```


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The value used for the resource names | `string` | `infrastructure` | no |
| alb_deletion_protection | Enable or disable ALB deletion protection | `bool` | `true` | no |
| vpc_id | The VPC ID where the resources should be created | `string` | `` | yes |
| subnets_id | The Subnets ID where the resources should be created | `string` | `` | yes |
| alb_https_expose | Enable or disable HTTPS exposure. If true, it should use the `certificate_arn` | `bool` | `true` | no |
| certificate_arn | The ARN for the certificate to be used on the ALB. It is required when `alb_https_expose` is true | `string` | `null` | no |
| alb_target_group_port | The port that the target group should communicate with the tasks | `number` | `80` | no |
| zone_name | The name of the zone where the CNAME for the ALB will be created | `string` | `null` | no |
| ecs_task_cpu | Number of CPU unit desired on the ECS task | `number` | `256` | no |
| ecs_task_memory | Number of memory desired on the ECS task | `number` | `512` | no |
| ecs_flask_api_port | The port to be used for communication with the API | `number` | `8080` | no |
| ecs_task_public_ip | Sets whether the tasks will have a public IP associated with them or not | `bool` | `true` | no |
| frontend_docker_image | Image to be used on the frontend container. If not declared, the ECS service will not be created | `string` | `null` | no |
| flask_api_docker_image | Image to be used on the API container. If not declared, the ECS service will not be created | `string` | `null` | no |
| ecr_repositories_arn | The ECR repositories that the tasks will have permission to download images from | `string` | `` | yes |


## Outputs

| Name | Description |
|------|-------------|
| alb_dns_name | A string with the ALB dns name |
| alb_arn | A string with the ALB arn |
| alb_target_group_arn | A string with the target group arn |
| alb_target_group_name | A string with the target group name |
| alb_security_group_id | A string with the ALB security group ID |
| ecs_task_security_group_id | A string with the ECS task security group ID |
| ecs_cluster_name | A string with the ECS cluster name |
| ecs_cluster_arn | A string with the ECS cluster arn |
| ecs_task_definition_arn | A string with the ECS task definition arn |
| ecs_task_definition_revision | A string with the ECS task definition revision |
| ecs_service_name | A string with the ECS service name |
| ecs_task_execution_role_arn | A string with the ECS task execution role arn |
| ecs_task_role_arn | A string with the ECS task role arn |
| dns_name | A string with the DNS name |
