resource "aws_iam_user" "team_ec2_ops" {
  for_each = toset([
    "kang",
    "nam",
    "kim"
  ])

  name = each.value
}

resource "aws_iam_group" "ec2_start_stop_group" {
  name = "mirrorsoul-ec2-start-stop"
}

resource "aws_iam_group_membership" "ec2_start_stop_membership" {
  name  = "mirrorsoul-ec2-start-stop-membership"
  group = aws_iam_group.ec2_start_stop_group.name

  users = [
    for user in aws_iam_user.team_ec2_ops : user.name
  ]
}

resource "aws_iam_policy" "ec2_start_stop_policy" {
  name = "mirrorsoul-ec2-start-stop-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceStatus",
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group_policy_attachment" "attach_ec2_start_stop_policy" {
  group      = aws_iam_group.ec2_start_stop_group.name
  policy_arn = aws_iam_policy.ec2_start_stop_policy.arn
}