data "aws_ami" "amazon_linux_2023" {
    most_recent = true
    owners = ["amazon"]

    filter {
        name = "name"
        values = ["al2023-ami-*-x86_64"]
    }
}

resource "aws_instance" "api_server" {
    ami                     = data.aws_ami.amazon_linux_2023.id
    instance_type           = "t3.micro"
    subnet_id               = aws_subnet.public_a.id
    vpc_security_group_ids  = [aws_security_group.sg_api_server.id]
    key_name                = "mirrorsoul-api-key"

    tags = {
        Name = "mirrorsoul-api-server"
    }
}