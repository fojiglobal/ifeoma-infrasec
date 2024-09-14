###################### Public Subnets ######################
resource "aws_subnet" "staging_pub_1" {
  vpc_id     = aws_vpc.staging.id
  cidr_block = "10.30.10.0/24"
  availability_zone = var.us_east_2b
  map_public_ip_on_launch = true      # auto-assign public IP to instance launched in this subnet

  tags = {
    Name = "staging-pub-1"
  }
}

resource "aws_subnet" "staging_pub_2" {
  vpc_id     = aws_vpc.staging.id
  cidr_block = "10.30.20.0/24"
  availability_zone = var.us_east_2c
  map_public_ip_on_launch = true      # auto-assign public IP to instance launched in this subnet

  tags = {
    Name = "staging-pub-2"
  }
}

###################### Private Subnets ######################
resource "aws_subnet" "staging_prv_1" {
  vpc_id     = aws_vpc.staging.id
  cidr_block = "10.30.30.0/24"
  availability_zone = var.us_east_2b

  tags = {
    Name = "staging-prv-1"
  }
}

resource "aws_subnet" "staging_prv_2" {
  vpc_id     = aws_vpc.staging.id
  cidr_block = "10.30.40.0/24"
  availability_zone = var.us_east_2c

  tags = {
    Name = "staging-prv-2"
  }
}