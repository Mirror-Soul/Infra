# API 서버 IAM ROLE
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

# API 서버 S3 정책
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

# API 서버 SQS 정책
resource "aws_iam_role_policy" "api_sqs_policy" {
  name = "mirrorsoul-api-sqs-policy"
  role = aws_iam_role.api_server_role.id

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = [
          "sqs:SendMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes"
        ]

        Resource = aws_sqs_queue.ai_job_queue.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "api_server_profile" {
  name = "mirrorsoul-api-server-profile"
  role = aws_iam_role.api_server_role.name
}

#---------------------------------AI------------------------------------#

# AI 서버 IAM ROLE 설정
resource "aws_iam_role" "ai_server_role" {
  name = "mirrorsoul-ai-server-role"

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

# AI 서버 S3, SQS 관련 IAM policy 설정
resource "aws_iam_role_policy" "ai_s3_sqs_policy" {
  name = "mirrorsoul-ai-s3-sqs-policy"
  role = aws_iam_role.ai_server_role.id

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
      },
      {
        Effect = "Allow"

        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes",
          "sqs:ChangeMessageVisibility"
        ]

        Resource = aws_sqs_queue.ai_job_queue.arn
      }
    ]
  })
}

resource "aws_iam_instance_profile" "ai_server_profile" {
  name = "mirrorsoul-ai-server-profile"
  role = aws_iam_role.ai_server_role.name
}