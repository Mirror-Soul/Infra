variable "db_password" {
  description = "RDS password"
  type        = string
  sensitive   = true
}

variable "postgresql_db_password" {
  description = "PostgreSQL RDS password"
  type        = string
  sensitive   = true
}
