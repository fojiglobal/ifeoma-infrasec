module "staging" {
  source = "./modules"

  # these are the variable names in variables.tf "/modules" folder
  vpc_cidr = local.vpc_cidr_block
  env = local.env
}

# Output exported from the outputs.tf in the /modules folder
output "vpc_id" {
  value = module.staging.vpc_id
}