resource "aws_security_group" "sg_api_server" {
    name = "mirrorsoul-api-sg"
    description = "Security group for API server"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "SSH"

        from_port = 22
        to_port   = 22
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        description = "Spring Boot API"

        from_port = 8080
        to_port   = 8080
        protocol  = "tcp"

        cidr_blocks = ["0.0.0.0/0"]
    }

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