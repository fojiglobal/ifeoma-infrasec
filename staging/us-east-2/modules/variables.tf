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
  type    = string
  default = "0.0.0.0/0"
}

variable "ami_id" {
  type    = string
  default = "ami-085f9c64a9b75eed5"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_pair" {
  type    = string
  default = "cs2-us-east-2-main"
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 4
}

variable "desired_capacity" {
  type    = number
  default = 2
}

variable "user_data" {
  type = string
}