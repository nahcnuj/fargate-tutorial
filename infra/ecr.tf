locals {
  ecr_lifecycle_policy = {
    rules = [
      {
        rulePriority = 1
        action = {
          type = "expire"
        }
        selection = {
          countNumber = 2
          countType   = "imageCountMoreThan"
          tagStatus   = "any"
        }
      },
    ]
  }
}

resource "aws_ecr_repository" "fargate-tutorial" {
  name = var.service

  encryption_configuration {
    encryption_type = "AES256"
  }

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_ecr_lifecycle_policy" "fargate-tutorial" {
  repository = aws_ecr_repository.fargate-tutorial.name
  policy     = jsonencode(local.ecr_lifecycle_policy)
}
