terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.95.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-north-1"
}