resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = var.vpc_name
  }
}

#########################################################################################
# Subnets
resource "aws_subnet" "public_subnet" {
  for_each          = { for idx, az in var.azs : idx => az }
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet_cidr[each.key]
  availability_zone = each.value

  tags = {
    "Name" = "snet-public-${each.value}"
  }
}

resource "aws_subnet" "private_subnet" {
  for_each          = { for idx, az in var.azs : idx => az }
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr[each.key]
  availability_zone = each.value

  tags = {
    "Name" = "snet-private-${each.value}"
  }
}

#Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "igw-${var.vpc_name}"
  }
}

# Route Table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "rtb-${var.vpc_name}-public"
  }
}

# Route table associations
resource "aws_route_table_association" "public_rta" {
  for_each       = aws_subnet.public_subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}
