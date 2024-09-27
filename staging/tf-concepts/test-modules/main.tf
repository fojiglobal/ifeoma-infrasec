locals {
  vpc_cidr = "10.120.0.0/16"
  env = "dev"
  public_subnets = {
    "pub-sub1" = {
      cidr = "10.120.1.0/24"
      azs = "us-east-2a"
      enable_public_ip = true
      tags = {
        Name = "pub-sub-1"
        Environment = "dev"
      }
    }
    "pub-sub2" = {
      cidr = "10.120.2.0/24"
      azs = "us-east-2b"
      enable_public_ip = true
      tags = {
        Name = "pub-sub-2"
        Environment = "dev"
      }
    }
    "pub-sub3" = {
      cidr = "10.120.3.0/24"
      azs = "us-east-2c"
      enable_public_ip = true
      tags = {
        Name = "pub-sub-3"
        Environment = "dev"
      }
    }
  }
  private_subnets = {
    "prv-sub1" = {
      cidr = "10.120.4.0/24"
      azs = "us-east-2a"
      tags = {
        Name = "prv-sub-1"
        Environment = "dev"
      }
    }
    "prv-sub2" = {
      cidr = "10.50.5.0/24"
      azs = "us-east-2b"
      tags = {
        Name = "prv-sub-2"
        Environment = "dev"
      }
    }
    "prv-sub3" = {
      cidr = "10.50.6.0/24"
      azs = "us-east-2c"
      tags = {
        Name = "prv-sub-3"
        Environment = "dev"
      }
    }
  }
}

module "dev" {
  source = "./modules"

  env = local.env
  vpc_cidr_block = local.vpc_cidr
  public_subnets = local.public_subnets
  private_subnets = local.private_subnets
}