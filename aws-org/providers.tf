terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # Remote State Management
  backend "s3" {
    bucket = "ifeoma-cs2-terraform"
    key    = "aws-org/terraform.tfstate"
    region = "us-east-2"
    # dynamodb_table = "cs2-infrasec-terraform"
  }
}

# AWS Provider
provider "aws" {
  region = "us-east-2"
}