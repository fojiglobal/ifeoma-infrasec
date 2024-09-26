# Single Value Data Types 

variable "cidr_block" {
  type = string
  default = "10.50.0.0/16"
}

variable "vpc_count" {
  type = number
  default = 2
}

variable "enable_dns" {
  type = bool
  default = false
}

# Multi-value Data Types 

variable "infrasec_users" {
  type = list(string)
  default = [ "jdoe", "jdone", "jbrown" ]
}

variable "executives" {
  type = list(string)
  default = [ "bobama", "jbiden", "kharris" ]
}

variable "vpcs" {
  type = map(object({
    cidr = string
    tags = map(string)
    tenancy = string
    enable_dns = bool
  }))
  default = {
    "staging" = {
      cidr = "10.50.0.0/16"
      tenancy = "default"
      enable_dns = false
      tags = {
        Name = "staging-vpc"
        Environment = "stg"
      }
    }
    "sandbox" = {
      cidr = "10.60.0.0/16"
      tenancy = "default"
      enable_dns = false
      tags = {
        Name = "sbx-vpc"
        Environment = "sbx"
      }
    }
    "production" = {
      cidr = "10.70.0.0/16"
      tenancy = "default"
      enable_dns = false
      tags = {
        Name = "prd-vpc"
        Environment = "prd"
      }
    }
  }
}

# Subnets 

variable "public_subnets" {
  type = map(object({
    cidr = string
    azs = string
    enable_public_ip = bool
    tags = map(string)
  }))
  default = {
    "pub-sub1" = {
      cidr = "10.50.1.0/24"
      azs = "us-east-2a"
      enable_public_ip = true
      tags = {
        Name = "pub-sub-1"
        Environment = "staging"
      }
    }
    "pub-sub2" = {
      cidr = "10.50.2.0/24"
      azs = "us-east-2b"
      enable_public_ip = true
      tags = {
        Name = "pub-sub-2"
        Environment = "staging"
      }
    }
    "pub-sub1" = {
      cidr = "10.50.3.0/24"
      azs = "us-east-2c"
      enable_public_ip = true
      tags = {
        Name = "pub-sub-3"
        Environment = "staging"
      }
    }
  }
}