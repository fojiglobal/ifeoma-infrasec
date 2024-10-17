module "staging" {
  # this module now uses the published module in "ifeoma-tf-modules" repo
  source = "github.com/fojiglobal/ifeoma-tf-modules//staging?ref=v1.0.0" 

  # these are the variable names in variables.tf "/modules" folder
  vpc_cidr        = local.vpc_cidr_block
  env             = local.env
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
  user_data       = filebase64("web.sh")

  # SG rules
  public_sg_ingress  = local.public_sg_ingress
  public_sg_egress   = local.public_sg_egress
  private_sg_ingress = local.private_sg_ingress
  private_sg_egress  = local.private_sg_egress
  bastion_sg_ingress = local.bastion_sg_ingress
  bastion_sg_egress  = local.bastion_sg_egress

  # this is to create only 1 NAT gateway for our public subnet, not all 3
  pub_sub_name = "pub-sub-1"

  # Route 53 
  my_domain_name = local.my_domain_name
  my_domain_env  = local.my_domain_env

  # Load balancer
  http_port       = local.http_port
  http_protocol   = local.http_protocol
  https_port      = local.https_port
  https_protocol  = local.https_protocol
  internet_facing = local.internet_facing
  lb_type         = local.lb_type
  alb_ssl_profile = local.alb_ssl_profile

  # DNS
  route53_target_health = local.route53_target_health
  record_type_A         = local.record_type_A
}

# Output exported from the outputs.tf in the /modules folder
output "vpc_id" {
  value = module.staging.vpc_id
}

# grabs all the public subnet IDs
output "pub_subnet_ids" {
  # value = module.staging.public_subnet_ids --> for the local module, just the a little difference in the name "public_subnets_ids"
  value = module.staging.public_subnet_ids
}

# grabs one of the public subnet ID
output "pub_subnet_id" {
  # value = module.staging.public_subnet_ids[0] --> for the local module, just the a little difference in the name "public_subnets_ids"
  value = module.staging.public_subnet_ids[0]
}

# grabs all the private subnet IDs
output "prv_subnet_ids" {
  # value = module.staging.private_subnet_ids --> for the local module, just the a little difference in the name "private_subnets_ids"
  value = module.staging.private_subnet_ids
}

# grabs one of the private subnet ID
output "prv_subnet_id" {
  # value = module.staging.private_subnet_ids[0] --> for the local module, just the a little difference in the name "private_subnets_ids"
  value = module.staging.private_subnet_ids[0]
}

