resource "aws_iam_role" "github_actions_ecr_perion" {
  name               = "GitHubActions-ECR-perion"
  assume_role_policy = data.aws_iam_policy_document.github_actions_assume_role.json
  description        = "Role for GitHub Actions to push to ECR (metarhos/perion)"
}

data "aws_iam_policy_document" "github_actions_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:metarhos/perion:*"]
    }
  }
}

resource "aws_iam_policy" "ecr_push_perion" {
  name        = "GitHubActions-ECR-perion-Push"
  description = "Minimum permissions for GitHub Actions to push to ECR"
  policy      = data.aws_iam_policy_document.ecr_push_perion.json
}

data "aws_iam_policy_document" "ecr_push_perion" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken",
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:UploadLayerPart",
      "ecr:CompleteLayerUpload",
      "ecr:PutImage"
    ]
    resources = ["*"] # These are account-level permissions
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:CreateRepository",
      "ecr:DescribeRepositories"
    ]
    resources = [
      "arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.ecr_repository_name}"
    ]
  }
}

resource "aws_iam_role_policy_attachment" "ecr_push_perion" {
  role       = aws_iam_role.github_actions_ecr_perion.name
  policy_arn = aws_iam_policy.ecr_push_perion.arn
}

data "aws_caller_identity" "current" {}

output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_ecr_perion.arn
  description = "ARN of the IAM role for GitHub Actions"
}