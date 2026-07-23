resource "aws_security_group" "postgresql" {
  name        = "mirrorsoul-postgresql-sg"
  description = "Allow PostgreSQL from API server only"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "PostgreSQL from API server"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"

    security_groups = [
      aws_security_group.sg_api_server.id
    ]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "mirrorsoul-postgresql-sg"
  }
}

resource "aws_db_instance" "postgresql" {
  identifier = "mirrorsoul-vector-db"

  engine         = "postgres"
  engine_version = "17"
  instance_class = "db.t4g.micro"

  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp3"
  storage_encrypted     = true

  db_name  = "mirrorsoul_vector"
  username = "postgres"
  password = var.postgresql_db_password
  port     = 5432

  db_subnet_group_name = aws_db_subnet_group.main.name
  vpc_security_group_ids = [
    aws_security_group.postgresql.id
  ]

  publicly_accessible        = false
  multi_az                   = false
  backup_retention_period    = 7
  auto_minor_version_upgrade = true

  skip_final_snapshot = true
  deletion_protection = false

  tags = {
    Name = "mirrorsoul-vector-db"
  }
}