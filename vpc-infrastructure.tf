# Create the VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = {
    Name = "${values(var.tags)[0]}-VPC"
  }
}

# Create the internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${values(var.tags)[0]}-IGW"
  }
}

# Create 2 public subnets
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "${values(var.tags)[0]}-Public${count.index + 1}"
  }
}

# Create and associate route tables to the public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${values(var.tags)[0]}-Public-Route"
  }
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = var.destination_cidr_block
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Create 2 private subnets for EC2 instances
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index + 10)
  tags = {
    Name = "${values(var.tags)[0]}-Private${count.index + 1}"
  }
}

# Creating Elastic IP, NAT gateway and route them to the private subnets
resource "aws_eip" "nat" {
  count = 1
  vpc   = true
  tags = {
    Name = "${values(var.tags)[0]}-EIP"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = 1
  allocation_id = aws_eip.nat[0].id
  subnet_id     = element(aws_subnet.public.*.id, 0)
  tags = {
    Name = "${values(var.tags)[0]}-NAT"
  }
}

resource "aws_route_table" "private" {
  count  = 2
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${values(var.tags)[0]}-Private-Route${count.index + 1}"
  }
}

resource "aws_route" "private" {
  count                  = 2
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = var.destination_cidr_block
  nat_gateway_id         = aws_nat_gateway.nat[0].id
}

resource "aws_route_table_association" "private" {
  count          = 2
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

