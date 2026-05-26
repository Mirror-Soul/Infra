# aws_vpc.main 이라는 VPC를 생성.
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"      # private IP 범위


  enable_dns_support   = true     # 나중에 지워야 함. 로컬 workbench에서 rds 접속하기 위해 적은 것.
  enable_dns_hostnames = true     # 나중에 지워야 함.

  tags = {
    Name = "mirrorsoul-vpc"
  }
}

# 1st public subnet. API와 AI 둘 다 포함되어있는 서브넷.
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true

  tags = {
    Name = "mirrorsoul-public-subnet-a"
  }
}

# 2nd public subnet. RDS가 포함되어 있는 서브넷
resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true

  tags = {
    Name = "mirrorsoul-public-b"
  }
}

# internet gateway. vpc와 외부인터넷이 통신
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "mirrorsoul-igw"
  }
}

# route table. 서브넷에서 외부로 나갈 때 igw를 사용함.
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

#subnet a랑 route table이랑 연결
resource "aws_route_table_association" "rta_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.rt.id
}

#subnet b랑 route table이랑 연결
resource "aws_route_table_association" "rta_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.rt.id
}