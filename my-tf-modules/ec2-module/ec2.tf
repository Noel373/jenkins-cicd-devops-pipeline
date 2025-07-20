provider "aws" {
  region = "us-east-1" # Change to your preferred AWS region
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "6.0.2"

  name = "jenkins-server"

  instance_type = var.instance_type
  key_name      = var.key_name
  monitoring    = true
  ami = var.ami_id 
  subnet_id     = "subnet-071cf6db72221f177" 
  availability_zone = var.availability_zone

  tags = {
    name        = var.instance_name
    Environment = var.environment
  }
}
