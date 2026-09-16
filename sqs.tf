# 목소리 생성 작업 요청 용 SQS 생성
resource "aws_sqs_queue" "ai_job_queue" {
  name = "mirrorsoul-ai-job-queue"

  visibility_timeout_seconds = 1800   # AI가 작업 가져가면 30분동안 다른 서버가 해당 작업 못 가져감
  message_retention_seconds  = 345600 # 메세지 최대 4일 보관
  receive_wait_time_seconds  = 20     # long polling
}

# 얼굴 가공 작업 요청 용 SQS 생성
resource "aws_sqs_queue" "face_training_queue" {
  name = "mirrorsoul-face-training-queue"

  visibility_timeout_seconds = 3600
  message_retention_seconds = 345600
  receive_wait_time_seconds = 20
}

# 밸런스게임 성향 분석 작업 요청용 SQS
resource "aws_sqs_queue" "value_balance_analysis_queue" {
  name = "mirrorsoul-value-balance-analysis-queue"

  visibility_timeout_seconds = 300
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 20
}

# ------------------------------------------------------------------
# 얼굴 결과 처리 실패 메시지 보관용 DLQ
resource "aws_sqs_queue" "face_training_result_dlq" {
  name = "mirrorsoul-face-training-result-dlq"

  message_retention_seconds = 1209600 # 14일 보관
  sqs_managed_sse_enabled    = true
}

# 얼굴 가공 결과 전달용 SQS: GPU → 백엔드
resource "aws_sqs_queue" "face_training_result_queue" {
  name = "mirrorsoul-face-training-result-queue"

  visibility_timeout_seconds = 120    # 백엔드 결과 저장 처리 시간
  message_retention_seconds  = 345600 # 4일 보관
  receive_wait_time_seconds  = 10     # long polling
  sqs_managed_sse_enabled     = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.face_training_result_dlq.arn
    maxReceiveCount     = 5
  })
}

# 해당 결과 큐에서만 이 DLQ를 사용하도록 제한
resource "aws_sqs_queue_redrive_allow_policy" "face_training_result_dlq" {
  queue_url = aws_sqs_queue.face_training_result_dlq.url

  redrive_allow_policy = jsonencode({
    redrivePermission = "byQueue"
    sourceQueueArns = [
      aws_sqs_queue.face_training_result_queue.arn
    ]
  })
}

# 백엔드와 GPU에 설정할 결과 큐 URL
output "face_training_result_queue_url" {
  value = aws_sqs_queue.face_training_result_queue.url
}

# IAM 권한 설정에 사용할 결과 큐 ARN
output "face_training_result_queue_arn" {
  value = aws_sqs_queue.face_training_result_queue.arn
}