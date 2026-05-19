resource "aws_instance" "api_server" {
    ami                     = "ami-01cbcf53c1503fe8a"
    instance_type           = "t3.micro"
    subnet_id               = aws_subnet.public_a.id
    vpc_security_group_ids  = [aws_security_group.sg_api_server.id]
    key_name                = "mirrorsoul-api-key"

    iam_instance_profile = aws_iam_instance_profile.api_server_profile.name

    root_block_device {
        volume_size = 10
        volume_type = "gp3"
    }

    tags = {
        Name = "mirrorsoul-api-server"
    }
}

resource "aws_instance" "ai_server" {
    ami                     = "ami-01cbcf53c1503fe8a"
    instance_type           = "t3.small"
    subnet_id               = aws_subnet.public_a.id
    vpc_security_group_ids  = [aws_security_group.sg_ai_server.id]
    key_name                = "mirrorsoul-ai-key"

    iam_instance_profile = aws_iam_instance_profile.api_server_profile.name     # 나중에 분리해줘야 함

    root_block_device {
        volume_size = 20
        volume_type = "gp3"
    }

    tags = {
        Name = "mirrorsoul-ai-server"
    }
}