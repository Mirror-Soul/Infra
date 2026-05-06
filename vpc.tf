resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "mirrorsoul-vpc"
    }
}

resource "aws_subnet" "public_a" {
    vpc_id                  = aws_vpc.main.id
    cidr_block              = "10.0.1.0/24"
    availability_zone       = "ap-northeast-2a"
    map_public_ip_on_launch = true

    tags = {
        Name = "mirrorsoul-public-subnet-a"
    } 
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.main.id

    tags = {
        Name = "mirrorsoul-igw"
    }
}

resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.main.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "mirrorsoul-public-rt"
    }
}

resource "aws_route_table_association" "rta" {
    subnet_id = aws_subnet.public_a.id
    route_table_id = aws_route_table.rt.id
}