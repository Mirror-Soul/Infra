# 목소리 생성 작업 요청 용 SQS 생성
resource "aws_sqs_queue" "ai_job_queue" {
  name = "mirrorsoul-ai-job-queue"

  visibility_timeout_seconds = 1800   # AI가 작업 가져가면 30분동안 다른 서버가 해당 작업 못 가져감
  message_retention_seconds  = 345600 # 메세지 최대 4일 보관
  receive_wait_time_seconds  = 20     # long polling
}