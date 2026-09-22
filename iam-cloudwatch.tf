# 기존 EC2 역할에 CloudWatch Agent 권한을 추가합니다.
# 기존 인라인 정책과 다른 관리형 정책 연결은 유지합니다.
resource "aws_iam_role_policy_attachment" "api_server_cloudwatch_agent" {
  role       = aws_iam_role.api_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ai_server_cloudwatch_agent" {
  role       = aws_iam_role.ai_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "call_server_cloudwatch_agent" {
  role       = aws_iam_role.call_server_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}
