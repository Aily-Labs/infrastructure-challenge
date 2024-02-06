module "ecr" {
  source = "./modules/ecr"

  repositories_name = [
    "flask-api",
    "frontend"
  ]
}

module "github_openid" {
  source               = "./modules/github"
  ecr_repositories_arn = module.ecr.repositories_arn
}

module "github_openid" {
  source               = "./modules/github"
  ecr_repositories_arn = module.ecr.repositories_arn
}

module "ecs" {
  source = "../../backup/jefferson/infrastructure-challenge/terraform/modules/ecs"

  vpc_id     = ""
  subnets_id = []

  alb_https_expose     = false
  ecr_repositories_arn = module.ecr.repositories_arn
}
