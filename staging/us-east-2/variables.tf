variable "staging_vpc_cidr" {
  type    = string
  default = "10.30.0.0/16"
}

variable "qa_vpc_cidr" {
  type    = string
  default = "10.40.0.0/16"
}

variable "us_east_2b" {
  type    = string
  default = "us-east-2b"
}

variable "us_east_2c" {
  type    = string
  default = "us-east-2c"
}

variable "my_region" {
  type = string
  default = "us-east-2"
}