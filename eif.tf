resource "aws_eip" "api_server_eip" {
  domain = "vpc"

  tags = {
    Name = "mirrorsoul-api-server-eip"
  }
}

resource "aws_eip_association" "api_server_eip_assoc" {
  instance_id   = aws_instance.api_server.id
  allocation_id = aws_eip.api_server_eip.id
}