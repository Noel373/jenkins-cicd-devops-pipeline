module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "5.1.0"

  bucket = "my-vpc-backend-bucket003"
  acl    = "private"
  region = "eu-west-1"
  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}