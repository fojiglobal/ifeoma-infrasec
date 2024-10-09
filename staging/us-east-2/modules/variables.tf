variable "vpc_cidr" {
  type = string
}

variable "env" {
  type = string
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    azs  = string
    tags = map(string)
  }))
}

variable "map_public_ip" {
  type    = bool
  default = true
}

variable "private_subnets" {
  type = map(object({
    cidr = string
    azs  = string
    tags = map(string)
  }))
}

variable "pub_sub_name" {
  type = string
}

variable "all_ipv4_cidr" {
  type = string
  default = "0.0.0.0/0"
}