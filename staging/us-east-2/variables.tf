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
  type    = string
  default = "us-east-2"
}

variable "env" {
  type    = string
  default = "staging"
}

variable "http_port" {
  type    = number
  default = 80
}

variable "http_protocol" {
  type    = string
  default = "HTTP"
}

variable "https_port" {
  type    = number
  default = 443
}

variable "https_protocol" {
  type    = string
  default = "HTTPS"
}

variable "alb_ssl_profile" {
  type    = string
  default = "ELBSecurityPolicy-2016-08"
}