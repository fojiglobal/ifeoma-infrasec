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
      azs  = "us-east-2a"
      tags = {
        Name        = "pub-sub-1"
        Environment = local.env
      }
    }
    "pub-sub-2" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 2)
      azs  = "us-east-2b"
      tags = {
        Name        = "pub-sub-2"
        Environment = local.env
      }
    }
    "pub-sub-3" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 3)
      azs  = "us-east-2c"
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
      azs  = "us-east-2a"
      tags = {
        Name        = "prv-sub-1"
        Environment = local.env
      }
    }
    "prv-sub-2" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 11)
      azs  = "us-east-2b"
      tags = {
        Name        = "prv-sub-2"
        Environment = local.env
      }
    }
    "prv-sub-3" = {
      cidr = cidrsubnet(local.vpc_cidr_block, 8, 12)
      azs  = "us-east-2c"
      tags = {
        Name        = "prv-sub-3"
        Environment = local.env
      }
    }
  }
}

################ Public SG Rules ################

locals {
  public_sg_ingress = {
    "all-http" = {
      src         = "0.0.0.0/0"
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "Allow HTTP from anywhere"
    }
    "all-https" = {
      src         = "0.0.0.0/0"
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "Allow HTTPS from anywhere"
    }
  }

  public_sg_egress = {
    "all-traffic" = {
      dest        = "0.0.0.0/0"
      ip_protocol = "-1"
      description = "Allow all traffic out"
    }
  }
}

################ Private SG Rules ################

locals {
  private_sg_egress = {
    "all-traffic" = {
      dest        = "0.0.0.0/0"
      ip_protocol = "-1"
      description = "Allow all traffic out"
    }
  }

  private_sg_ingress = {
    "alb-http" = {
      src         = module.staging.public_sg_id
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      description = "Allow HTTP from anywhere"
    }
    "alb-https" = {
      src         = module.staging.public_sg_id
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      description = "Allow HTTPS from anywhere"
    }
    "bastion-ssh" = {
      src         = module.staging.bastion_sg_id
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "Allow only SSH from bastion"
    }
  }
}

################ Bastion SG Rules ################

locals {
  bastion_sg_ingress = {
    "all-ssh" = {
      src         = "0.0.0.0/0"
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      description = "Allow SSH from anywhere"
    }
  }

  bastion_sg_egress = {
    "all-traffic" = {
      dest        = "0.0.0.0/0"
      ip_protocol = "-1"
      description = "Allow all traffic out"
    }
  }
}

################ Route 53 ################

locals {
  my_domain_name = "cloudwithify.online"
}

################ Load Balancer ################

locals {
  http_port       = 80
  http_protocol   = "HTTP"
  https_port      = 443
  https_protocol  = "HTTPS"
  internet_facing = false
  lb_type         = "application"
  alb_ssl_profile = "ELBSecurityPolicy-2016-08"
  my_domain_env   = "stg"
}