module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"

  name = "vpc-project003"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b"]
  private_subnets = ["10.0.4.0/23", "10.0.6.0/23"]
  public_subnets  = ["10.0.0.0/23", "10.0.2.0/23"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  create_database_subnet_group       = true
  database_subnet_group_name         = "my-database-subnet-group"
  create_database_subnet_route_table = true
  database_subnets                   = ["10.0.8.0/23", "10.0.10.0/23"]
  enable_dns_hostnames               = true
  enable_dns_support                 = true

  public_subnet_tags = {
    Type = "public"
  }

  private_subnet_tags = {
    Type = "private"
  }

  database_subnet_tags = {
    Type = "database"
  }

  vpc_tags = {
    Name = "vpc-project003"
  }

  tags = {
    owner       = "noelkin"
    Environment = "dev"
  }
}