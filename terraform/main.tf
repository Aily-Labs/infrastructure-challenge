module "ecr" {
  source = "../../backup/jefferson/infrastructure-challenge/terraform/modules/ecr"

  repositories_name = [
    "flask-api",
    "frontend"
  ]
}

module "github_openid" {
  source               = "../../backup/jefferson/infrastructure-challenge/terraform/modules/github"
  ecr_repositories_arn = module.ecr.repositories_arn
}

