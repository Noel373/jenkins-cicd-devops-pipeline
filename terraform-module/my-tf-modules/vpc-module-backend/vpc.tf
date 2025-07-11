module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"
  depends_on = [ module.s3_bucket ]

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.vpc_azs
  private_subnets = var.vpc_private_subnets
  public_subnets  = var.vpc_public_subnets   

# NAT Gateway - outbound internet access for private subnets
  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_enable_nat_gateway

  create_database_subnet_group       = var.vpc_create_database_subnet_group
  create_database_subnet_route_table = var.vpc_create_database_subnet_route_table
  database_subnets                   = var.vpc_database_subnets
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
    Name = var.vpc_name
  }

  tags = {
    owner       = "noelkin"
    Environment = "dev"
  }
}