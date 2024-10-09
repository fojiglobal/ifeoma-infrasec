###################### VPC ######################

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name        = "${var.env}-vpc"
    Environment = var.env
  }
}

###################### Public Subnets ######################

resource "aws_subnet" "public" {
  for_each = var.public_subnets

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["azs"]
  tags                    = each.value["tags"]
  map_public_ip_on_launch = var.map_public_ip
}

###################### Private Subnets ######################

resource "aws_subnet" "private" {
  for_each = var.private_subnets

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["azs"]
  tags              = each.value["tags"]
}

###################### Internet Gateway ######################

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.env}-igw"
  }
}

###################### NAT Gateway ######################

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[var.pub_sub_name].id
  depends_on    = [aws_internet_gateway.this]

  tags = {
    Name = "${var.env}-ngw"
  }
}

###################### Elastic IP for the NAT Gateway ######################

resource "aws_eip" "this" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.this]

  tags = {
    Name = "${var.env}-eip"
  }
}

###################### Route Tables ######################

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = var.all_ipv4_cidr
    gateway_id = aws_internet_gateway.this.id
  }

  tags = {
    Name        = "${var.env}-public-rt"
    Environment = var.env
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = var.all_ipv4_cidr
    nat_gateway_id = aws_nat_gateway.this.id
  }

  tags = {
    Name        = "${var.env}-private-rt"
    Environment = var.env
  }
}

##### Subnet Association to Route Tables #####

resource "aws_route_table_association" "public" {
  for_each = var.public_subnets

  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[each.key].id
}

resource "aws_route_table_association" "private" {
  for_each = var.private_subnets

  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[each.key].id
}