terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

resource "aws_ecr_repository" "this" {
  name                 = var.repository_name
  # image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false # can use the scan results in CI/CD or monitoring to decide whether to release the image for use or not.
  }

  tags = {
    Environment = var.environment
  }
}

resource "aws_ecr_lifecycle_policy" "this" {
  repository = aws_ecr_repository.this.name

  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Expire untagged images older than 14 days"
        selection = {
          tagStatus     = "untagged"
          countType     = "sinceImagePushed"
          countUnit     = "days"
          countNumber   = 14
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep last 3 tagged images starting with any prefix"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]  # set in CI all images with prefix v. Can't use "any" prefix
          countType     = "imageCountMoreThan"
          countNumber   = 3
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}