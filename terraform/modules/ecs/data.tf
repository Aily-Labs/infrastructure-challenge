data "aws_caller_identity" "current" {}

data "aws_iam_account_alias" "alias" {}

data "aws_region" "current" {}

data "aws_route53_zone" "this" {
  name = var.zone_name
}

data "aws_iam_policy_document" "ecs_trust" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "base" {
  statement {
    actions   = ["ecr:GetAuthorizationToken"]
    resources = ["*"]
  }
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    resources = var.ecr_repositories_arn
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      "${aws_cloudwatch_log_group.this.arn}*"
    ]
  }
}

data "aws_iam_policy_document" "this_ecs_task_ssm" {
  statement {
    sid    = "AllowSsmTask"
    effect = "Allow"
    actions = [
      "ssmmessages:CreateControlChannel",
      "ssmmessages:CreateDataChannel",
      "ssmmessages:OpenControlChannel",
      "ssmmessages:OpenDataChannel"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    sid    = "AllowUserExecuteCommand"
    effect = "Allow"
    actions = [
      "ecs:ExecuteCommand",
    ]
    resources = [
      "*"
    ]
  }
}
