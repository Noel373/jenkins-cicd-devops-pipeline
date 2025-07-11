
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }
  }

  required_version = ">= 1.3.0"
    # Configure the backend to use S3 for state management  

  backend "s3" {
  bucket         = "noelkin373"
  key            = "mydata/terraform/state"
    region         = "us-east-1"
 /* dynamodb_table = "terraform-locks"*/
}
}