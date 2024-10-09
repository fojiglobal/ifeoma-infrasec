module "staging" {
  source = "./modules"

  # these are the variable names in variables.tf "/modules" folder
  vpc_cidr        = local.vpc_cidr_block
  env             = local.env
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

# Output exported from the outputs.tf in the /modules folder
output "vpc_id" {
  value = module.staging.vpc_id
}

# grabs all the public subnet IDs
output "pub_subnet_ids" {
  value = module.staging.public_subnets_ids
}

# grabs one of the public subnet ID
output "pub_subnet_id" {
  value = module.staging.public_subnets_ids[0]
}