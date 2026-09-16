# 학교 GPU 서버에서 얼굴 영상 작업을 처리할 때 사용하는 전용 IAM User입니다.
# Access Key는 Terraform state에 저장하지 않도록 AWS 콘솔에서 별도로 발급합니다.
resource "aws_iam_user" "face_gpu_worker" {
  name = "mirrorsoul-face-gpu-worker"
}

resource "aws_iam_user_policy" "face_gpu_worker" {
  name = "mirrorsoul-face-gpu-worker-policy"
  user = aws_iam_user.face_gpu_worker.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
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
        Sid    = "DownloadSourceObjects"
        Effect = "Allow"
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.storage.arn}/*"
      },
      {
        Sid    = "UploadFaceModelResults"
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "${aws_s3_bucket.storage.arn}/face-results/*"
      },
      {
        Sid    = "ProcessFaceTrainingJobs"
        Effect = "Allow"
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:ChangeMessageVisibility",
          "sqs:GetQueueUrl",
          "sqs:GetQueueAttributes"
        ]
        Resource = aws_sqs_queue.face_training_queue.arn
      },
      {
        Sid      = "SendFaceTrainingResults"
        Effect   = "Allow"
        Action   = ["sqs:SendMessage"]
        Resource = aws_sqs_queue.face_training_result_queue.arn
      }
    ]
  })
}
