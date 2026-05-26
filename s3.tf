# S3 Bucket 생성
resource "aws_s3_bucket" "storage" {
  bucket = "mirrorsoul-storage-64"

  tags = {
    Name = "mirrorsoul-storage"
  }
}

# CORS 설정
resource "aws_s3_bucket_cors_configuration" "storage_cors" {
  bucket = aws_s3_bucket.storage.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["*"]                                       # 현재 모든 웹사이트에서 CORS 요청을 허용하므로, 운영 환경에서는 프론트 도메인만 허용하는 방식이 더 나을 수도 있음.
    expose_headers  = ["ETag"]

    max_age_seconds = 3000
  }
}

# Public 접근 차단 설정. 현재 전체 true 여서 외부에서 접근 불가
resource "aws_s3_bucket_public_access_block" "storage" {
  bucket = aws_s3_bucket.storage.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}