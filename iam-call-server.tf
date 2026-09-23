# Allow the CALL server to read face result artifacts.
resource "aws_iam_role_policy" "call_server_face_results" {
  name = "mirrorsoul-call-server-face-results-policy"
  role = aws_iam_role.call_server_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ListFaceResults"
        Effect   = "Allow"
        Action   = "s3:ListBucket"
        Resource = aws_s3_bucket.storage.arn
        Condition = {
          StringLike = {
            "s3:prefix" = "face-results/*"
          }
        }
      },
      {
        Sid      = "ReadFaceResults"
        Effect   = "Allow"
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.storage.arn}/face-results/*"
      }
    ]
  })
}
