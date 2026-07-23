# RDS가 들어갈 Subnet group
resource "aws_db_subnet_group" "main" {
  name = "mirrorsoul-rds-subnet-group"

  subnet_ids = [
    aws_subnet.public_a.id,
    aws_subnet.public_b.id
  ]

  tags = {
    Name = "mirrorsoul-rds-subnet-group"
  }
}

# RDS 용 Security group
resource "aws_security_group" "rds_sg" {
  name        = "mirrorsoul-rds-sg"
  description = "Allow MySQL from EC2 only"
  vpc_id      = aws_vpc.main.id

  # API Server에서의 접근 허용
  ingress {
    description = "MySQL from API Server"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    security_groups = [
      aws_security_group.sg_api_server.id
    ]
  }

  # AI Server에서의 접근 허용
  ingress {
    description = "MySQL from AI Server"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    security_groups = [
      aws_security_group.sg_ai_server.id
    ]
  }

  # 전체 허용. !임시 개발용!
  ingress {
    description = "MySQL from ALL"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

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
    Name = "mirrorsoul-rds-sg"
  }
}

# 실제 MySQL RDS 인스턴스
resource "aws_db_instance" "mysql" {
  identifier = "mirrorsoul-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage     = 20                # 시작은 20GB, 필요 시 100GB까지 자동 증가 가능.
  max_allocated_storage = 100
  storage_type          = "gp2"

  db_name  = "mirrorsoul"
  username = "admin"
  password = var.db_password                # 변수로 관리

  db_subnet_group_name = aws_db_subnet_group.main.name            # subnet group을 연결

  vpc_security_group_ids = [                                      # security group을 연결
    aws_security_group.rds_sg.id
  ]

  publicly_accessible     = true                                  # RDS에 퍼블릭 주소를 부여해서 외부 인터넷에서 접근 가능하게 함. 운영 시 제거가 필요함.
  multi_az                = false                                 # 고가용성 구조 x
  skip_final_snapshot     = true                                  # 삭제 시 최종 백업 스냅샷을 만들지 않음.
  deletion_protection     = false                                 # 실수로 삭제되게 하지 않음.
  backup_retention_period = 0                                     # 자동 백업 보관 안함.

  tags = {
    Name = "mirrorsoul-mysql"
  }
}