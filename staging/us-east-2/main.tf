# Create VPC
resource "aws_vpc" "staging" {
  cidr_block = var.staging_vpc_cidr

  tags = {
    Name        = "staging-vpc"
    Environment = "staging"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "staging" {
  vpc_id = aws_vpc.staging.id

  tags = {
    Name = "staging-igw"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "staging" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.staging_pub_1.id

  tags = {
    Name = "staging-ngw"
  }

  # To ensure proper ordering, add an explicit dependency
  depends_on = [aws_internet_gateway.staging]
}

# Create an Elastic IP for the NAT Gateway
resource "aws_eip" "natgw_eip" {
  domain = "vpc"

  tags = {
    Name = "ngw-eip"
  }

  depends_on = [aws_internet_gateway.staging]
}