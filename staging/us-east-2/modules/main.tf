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