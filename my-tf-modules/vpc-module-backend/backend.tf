/*terraform {
  backend "s3" {
    bucket         = "my-vpc-backend-bucket003"
    key            = "project003/vpc/terraform.tfstate"
    region         = "eu-west-1"
    dynamodb_table = "THE_ID_OF_THE_DYNAMODB_TABLE"
  }
}


resource "aws_dynamodb_table" "vpc_state_lock" {
  name         = "vpc_state_lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  read_capacity = 3
  write_capacity = 3


  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name        = "vpc_state_lock"
    Environment = "dev"
  } 
  
}

*/