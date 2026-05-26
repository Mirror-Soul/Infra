# API 서버 IAM ROLE
resource "aws_iam_role" "api_server_role" {
  name = "mirrorsoul-api-server-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"           # EC2가 이 Role을 사용할 수 있음을 표시
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
          "s3:ListBucket"                                     # 버킷 안의 객체 목록을 조회할 수 있는 권한
        ]

        Resource = [
          aws_s3_bucket.storage.arn                           # 버킷 자체에 대한 권한이라 /* 없음.
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

# 생성한 Role을 API Server EC2에 붙일 수 있도록 instance profile을 생성함.
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

# 생성한 Role을 AI Server EC2에 붙일 수 있도록 instance profile을 생성함.
resource "aws_iam_instance_profile" "ai_server_profile" {
  name = "mirrorsoul-ai-server-profile"
  role = aws_iam_role.ai_server_role.name
}