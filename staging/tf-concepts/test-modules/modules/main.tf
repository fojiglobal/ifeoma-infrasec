# Create VPC

resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Environment = var.env
  }
}

# Subnets

resource "aws_subnet" "public_subnets" {
  for_each = var.public_subnets

  vpc_id = aws_vpc.this.id
  cidr_block = each.value["cidr"]
  availability_zone = each.value["azs"]
  map_public_ip_on_launch = each.value["enable_public_ip"]
  tags = each.value["tags"]
}

resource "aws_subnet" "private_subnets" {
  for_each = var.private_subnets

  vpc_id = aws_vpc.this.id
  cidr_block = each.value["cidr"]
  availability_zone = each.value["azs"]
  tags = each.value["tags"]
}