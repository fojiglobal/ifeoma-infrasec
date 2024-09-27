variable "vpc_cidr_block" {
  type = string
}

variable "enable_dns" {
  type = bool
  default = false
}

variable "env" {
  type = string
}

# Subnets 

variable "public_subnets" {
  type = map(object({
    cidr = string
    azs = string
    enable_public_ip = bool
    tags = map(string)
  }))
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    azs = string
    tags = map(string)
  }))
}