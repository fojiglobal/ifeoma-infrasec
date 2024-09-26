# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
}

# Create Users using the "count" loop

resource "aws_iam_user" "infrasec_users" {
  count = length(var.infrasec_users)
  name = "user-${var.infrasec_users[count.index]}"
}

# Output of a specific user

output "jbrown_user" {
  value = aws_iam_user.user_name[2].name
}

# Output of all users 

output "all_users" {
  value = aws_iam_user.user_name[*].name
}

# Create Users using the "for_each" loop

# For the "list" variable type, the "toset" is needed

resource "aws_iam_user" "infrasec_execs" {
  for_each = toset(var.executives)
  name = each.value
}

# For the "map" variable type, the "toset" is not needed
resource "aws_vpc" "vpc_loops" {
  for_each = var.vpcs
  cidr_block = each.value["cidr"]
  enable_dns_hostnames = each.value["enable_dns"]
  tags = each.value["tags"]
}

# Get all VPCs

output "vpcs" {
  value = aws_vpc.vpc_loops[*]
}

# Get a specific VPC

output "sbx_vpc" {
  value = aws_vpc.vpc_loops["sandbox"].id
}