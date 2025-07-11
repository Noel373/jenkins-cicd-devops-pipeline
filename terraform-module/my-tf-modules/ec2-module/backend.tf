/*backend "s3" {
  bucket         = "noelkin373"
  key            = "terraform/state"
    region         = "us-east-1"
  dynamodb_table = "terraform-locks"
}

resource "aws-s3" "noelkin373" {
  bucket = "noelkin373"
  acl    = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name        = "noelkin373"
    Environment = "dev"
  } 
  
}



#locking state for terraform
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-locks"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "terraform-locks"
    Environment = "dev"
  }
    lifecycle {
        prevent_destroy = true
    }   
}   
*/