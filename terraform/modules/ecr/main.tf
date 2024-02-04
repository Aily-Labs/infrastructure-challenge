resource "aws_ecr_repository" "this" {
  count                = length(var.repositories_name)
  name                 = var.repositories_name[count.index]
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }
}

resource "aws_ecr_lifecycle_policy" "this_rule_untagged" {
  count = length(var.repositories_name)

  repository = element(aws_ecr_repository.this[*].name, count.index)

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Expire untagged images older than 10 days"
        selection = {
          tagStatus   = "untagged",
          countType   = "sinceImagePushed",
          countUnit   = "days",
          countNumber = 10
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
}
