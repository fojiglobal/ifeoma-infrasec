################ VPC ################

# NOTE: the keys can be any name
locals {
  vpc_cidr_block = "10.50.0.0/16"
  env            = "staging"
}

################ Public Subnets ################

locals {
  public_subnets = {
    "pub-sub-1" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 1)
      azs         = "us-east-2a"
      tags = {
        Name        = "pub-sub-1"
        Environment = local.env
      }
    }
    "pub-sub-2" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 2)
      azs         = "us-east-2b"
      tags = {
        Name        = "pub-sub-2"
        Environment = local.env
      }
    }
    "pub-sub-3" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 3)
      azs         = "us-east-2c"
      tags = {
        Name        = "pub-sub-3"
        Environment = local.env
      }
    }
  }
}

################ Private Subnets ################

locals {
  private_subnets = {
    "prv-sub-1" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 10)
      azs         = "us-east-2a"
      tags = {
        Name        = "prv-sub-1"
        Environment = local.env
      }
    }
    "prv-sub-2" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 11)
      azs         = "us-east-2b"
      tags = {
        Name        = "prv-sub-2"
        Environment = local.env
      }
    }
    "prv-sub-3" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 12)
      azs         = "us-east-2c"
      tags = {
        Name        = "prv-sub-3"
        Environment = local.env
      }
    }
  }
}