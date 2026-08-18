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

# kim 사용자가 S3 버킷/객체와 SQS 큐/메시지를 조회할 수 있는 읽기 전용 정책
resource "aws_iam_user_policy" "kim_storage_queue_read_only" {
  name = "mirrorsoul-storage-queue-read-only"
  user = aws_iam_user.team_ec2_ops["kim"].name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "ListS3Buckets"
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets"
        ]
        Resource = "*"
      },
      {
        Sid    = "ReadStorageBucket"
        Effect = "Allow"
        Action = [
          "s3:GetBucketLocation",
          "s3:ListBucket"
        ]
        Resource = aws_s3_bucket.storage.arn
      },
      {
        Sid    = "ReadStorageObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.storage.arn}/*"
      },
      {
        Sid    = "ListSqsQueues"
        Effect = "Allow"
        Action = [
          "sqs:ListQueues"
        ]
        Resource = "*"
      },
      {
        Sid    = "ReadQueueMessages"
        Effect = "Allow"
        Action = [
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ReceiveMessage"
        ]
        Resource = [
          aws_sqs_queue.ai_job_queue.arn,
          aws_sqs_queue.face_training_queue.arn
        ]
      }
    ]
  })
}
