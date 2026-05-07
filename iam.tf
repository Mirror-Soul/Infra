resource "aws_iam_role" "api_server_role" {
    name = "mirrorsoul-api-server-role"

    assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "mirrorsoul-s3-policy"
  role = aws_iam_role.api_server_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]

        Resource = [
          "${aws_s3_bucket.storage.arn}/*"
        ]
      },
      {
        Effect = "Allow"

        Action = [
          "s3:ListBucket"
        ]

        Resource = [
          aws_s3_bucket.storage.arn
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "api_server_profile" {
  name = "mirrorsoul-api-server-profile"
  role = aws_iam_role.api_serer_role.name
}