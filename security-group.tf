# API Server 용 security group
resource "aws_security_group" "sg_api_server" {
  name        = "mirrorsoul-api-sg"
  description = "Security group for API server"
  vpc_id      = aws_vpc.main.id

  # SSH 접속 허용
  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]     # 운영 환경에서는 내 IP로 제한해 놓는게 좋음.
  }

  # Spring Boot API 접속 허용
  ingress {
    description = "Spring Boot API"

    from_port = 8080
    to_port   = 8080
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP 접속 허용
  ingress {
    description = "HTTP"

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS 접속 허용
  ingress {
    description = "HTTPS"

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # 모든 곳으로 outbound 가능
  egress {
    description = "Allow all outbound"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mirrorsoul-api-sg"
  }
}

# AI Server 용 security group
resource "aws_security_group" "sg_ai_server" {
  name        = "mirrorsoul-ai-sg"
  description = "Security group for AI server"
  vpc_id      = aws_vpc.main.id

  # SSH 접속 허용
  ingress {
    description = "SSH"

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # 굳이 안열어도 되지만 swagger나 그런거 사용 위해 열어둠
  ingress {
    description = "FastAPI"

    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  # 모든 곳으로 outbound 가능
  egress {
    description = "Allow all outbound"

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mirrorsoul-ai-sg"
  }
}

# Call Server 용 security group
resource "aws_security_group" "sg_call_server" {
  name        = "mirrorsoul-call-server-sg"
  description = "Security group for call server"
  vpc_id      = aws_vpc.main.id

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # FastAPI / WebSocket
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # WebRTC Signaling HTTPS 쓰면 나중에 443
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # WebRTC UDP 포트 범위
  ingress {
    from_port   = 10000
    to_port     = 20000
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound 전체 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mirrorsoul-call-server-sg"
  }
}