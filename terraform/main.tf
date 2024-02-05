module "github_openid" {
  source = "./modules/github"
}

module "ecr" {
  source = "./modules/ecr"

  repositories_name = [
    "flask-api",
    "frontend"
  ]
}

