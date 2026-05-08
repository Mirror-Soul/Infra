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

resource "aws_security_group" "rds_sg" {
  name        = "mirrorsoul-rds-sg"
  description = "Allow MySQL from EC2 only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "MySQL from API Server"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"

    security_groups = [
      aws_security_group.sg_api_server.id
    ]
  }

  ingress {
    description = "MySQL from my PC"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    cidr_blocks = ["39.115.12.8/32"]
  }

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

resource "aws_db_instance" "mysql" {
  identifier = "mirrorsoul-mysql"

  engine         = "mysql"
  engine_version = "8.0"

  instance_class = "db.t3.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"

  db_name  = "mirrorsoul"
  username = "admin"
  password = var.db_password

  db_subnet_group_name = aws_db_subnet_group.main.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = true
  multi_az            = false
  skip_final_snapshot = true
  deletion_protection = false
  backup_retention_period = 0

  tags = {
    Name = "mirrorsoul-mysql"
  }
}