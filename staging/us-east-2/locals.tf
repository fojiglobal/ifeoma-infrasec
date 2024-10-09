################ VPC ################

# NOTE: the keys can be any name
locals {
  vpc_cidr_block = "10.50.0.0/16"
  env = "staging"
}