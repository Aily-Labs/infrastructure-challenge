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

