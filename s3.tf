resource "aws_s3_bucket" "storage" {
    bucket = "mirrorsoul-storage-64"

    tags = {
        Name = "mirrorsoul-storage"
    }
}

resource "aws_s3_bucket_cors_configuration" "storage_cors" {
    bucket = aws_s3_bucket.storage.id

    cors_rule {
        allowed_headers = ["*"]
        allowed_methods = ["GET", "PUT", "POST"]
        allowed_origins = ["*"]
        expose_headers  = ["ETag"]

        max_age_seconds = 3000
    }
}

resource "aws_s3_bucket_public_access_block" "storage" {
    bucket = aws_s3_bucket.storage.id

    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
}