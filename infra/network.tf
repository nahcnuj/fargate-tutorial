resource "aws_vpc" "fargate-tutorial" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.fargate-tutorial.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "public | ap-northeast-1a"
  }
}

resource "aws_subnet" "private_a" {
  vpc_id            = aws_vpc.fargate-tutorial.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "private | ap-northeast-1a"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.fargate-tutorial.id

  tags = {
    Name = "public"
  }
}

resource "aws_route_table_association" "public_a_subnet" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.fargate-tutorial.id

  tags = {
    Name = "private"
  }
}

resource "aws_route_table_association" "private_a_subnet" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.fargate-tutorial.id
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "ngw" {
  subnet_id     = aws_subnet.public_a.id
  allocation_id = aws_eip.nat.id

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route" "public_igw" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route" "private_ngw" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.ngw.id
}

resource "aws_security_group" "egress_all" {
  name        = "egress-all"
  description = "allow all outbound traffic"
  vpc_id      = aws_vpc.fargate-tutorial.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # any protocol
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "egress-all"
  }
}

resource "aws_security_group" "ingress_app" {
  name        = "ingress-app"
  description = "allow ingress to app"
  vpc_id      = aws_vpc.fargate-tutorial.id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ingress-app"
  }
}
