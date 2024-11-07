resource "aws_vpc" "wsi-vpc" {
  cidr_block = "10.1.0.0/16"

  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    "Name" = "wsi-vpc"
  }

}

resource "aws_internet_gateway" "wsi-igw" {
  vpc_id = aws_vpc.wsi-vpc.id

  tags = {
    Name = "wsi-igw"
  }

}

resource "aws_subnet" "wsi-public-subnet-a" {
  vpc_id     = aws_vpc.wsi-vpc.id
  cidr_block = "10.1.0.0/24"

  availability_zone = "ap-northeast-2a"

  map_public_ip_on_launch = true

  tags = {
    "Name" = "wsi-public-subnet-a"
  }

}


resource "aws_subnet" "wsi-public-subnet-b" {
  vpc_id     = aws_vpc.wsi-vpc.id
  cidr_block = "10.1.1.0/24"

  availability_zone = "ap-northeast-2b"

  map_public_ip_on_launch = true

  tags = {
    "Name" = "wsi-public-subnet-b"
  }
}



resource "aws_route_table" "wsi-public-rt" {
  vpc_id = aws_vpc.wsi-vpc.id

  tags = {
    Name = "wsi-public-rt"
  }
}


resource "aws_route" "wsi_public_r" {
  route_table_id         = aws_route_table.wsi-public-rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.wsi-igw.id
}


resource "aws_route_table_association" "wsi-public-rt-a" {
  subnet_id      = aws_subnet.wsi-public-subnet-a.id
  route_table_id = aws_route_table.wsi-public-rt.id
}
resource "aws_route_table_association" "wsi-public-rt-b" {
  subnet_id      = aws_subnet.wsi-public-subnet-b.id
  route_table_id = aws_route_table.wsi-public-rt.id

}




resource "aws_subnet" "wsi-private-subnet-a" {
  vpc_id     = aws_vpc.wsi-vpc.id
  cidr_block = "10.1.2.0/24"

  availability_zone = "ap-northeast-2a"

  tags = {
    "Name" = "wsi-private-subnet-a"
  }
}

resource "aws_nat_gateway" "wsi-ngw-a" {
  depends_on = [aws_internet_gateway.wsi-igw, aws_eip.eip-a]

  allocation_id = aws_eip.eip-a.id
  subnet_id     = aws_subnet.wsi-public-subnet-a.id
  tags = {
    Name = "wsi-ngw-a"
  }
}

resource "aws_nat_gateway" "wsi-ngw-b" {
  depends_on = [aws_internet_gateway.wsi-igw, aws_eip.eip-b]

  allocation_id = aws_eip.eip-b.id
  subnet_id     = aws_subnet.wsi-public-subnet-b.id
  tags = {
    Name = "wsi-ngw-b"
  }

}

resource "aws_subnet" "wsi-private-subnet-b" {
  vpc_id     = aws_vpc.wsi-vpc.id
  cidr_block = "10.1.3.0/24"

  availability_zone = "ap-northeast-2b"

  tags = {
    "Name" = "wsi-private-subnet-b"
  }
}


resource "aws_route_table" "wsi-private-b-rt" {
  vpc_id = aws_vpc.wsi-vpc.id

  tags = {
    Name = "wsi-private-b-rt"
  }
}


resource "aws_route_table" "wsi-private-a-rt" {
  vpc_id = aws_vpc.wsi-vpc.id

  tags = {
    Name = "wsi-private-a-rt"
  }
}

resource "aws_eip" "eip-a" {
  vpc = true

  tags = {
    Name = "eip-a"
  }
}

resource "aws_eip" "eip-b" {
  vpc = true

  tags = {
    Name = "eip-b"
  }
}


resource "aws_route" "wsi-private-a-r" {
  route_table_id         = aws_route_table.wsi-private-a-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.wsi-ngw-a.id
}

resource "aws_route" "wsi-private-b-r" {
  route_table_id         = aws_route_table.wsi-private-b-rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.wsi-ngw-b.id
}



resource "aws_route_table_association" "wsi-private-a-rt" {
  subnet_id      = aws_subnet.wsi-private-subnet-a.id
  route_table_id = aws_route_table.wsi-private-a-rt.id
}

resource "aws_route_table_association" "wsi-private-b-rt" {
  subnet_id      = aws_subnet.wsi-private-subnet-b.id
  route_table_id = aws_route_table.wsi-private-b-rt.id

}




