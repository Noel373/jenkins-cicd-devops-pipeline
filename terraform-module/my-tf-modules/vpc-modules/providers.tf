terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }

  required_version = ">= 1.3.0"
}
provider "aws" {
  region = "eu-west-1" # Change to your preferred AWS region
}