resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.name}_task_execution_role"
  description        = "Custom ecs_task_execution_role for ${var.name}. This is used by the ECS Service"
  assume_role_policy = data.aws_iam_policy_document.ecs_trust.json
}

resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.name}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_trust.json
}

resource "aws_iam_role_policy" "base" {
  name_prefix = "${var.name}_base"
  policy      = data.aws_iam_policy_document.base.json
  role        = aws_iam_role.ecs_task_execution_role.id
}

resource "aws_iam_role_policy" "this_ecs_task_ssm" {
  name   = "${var.name}_ssm"
  policy = data.aws_iam_policy_document.this_ecs_task_ssm.json
  role   = aws_iam_role.ecs_task_role.name
}
