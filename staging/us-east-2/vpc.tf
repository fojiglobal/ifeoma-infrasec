module "staging" {
  source = "./modules"

  # these are the variable names in variables.tf "/modules" folder
  vpc_cidr = local.vpc_cidr_block
  env = local.env
}