output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
  
}
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnets" {
  description = "List of private subnets in the VPC"
  value       = module.vpc.private_subnets
}
output "public_subnets" {
  description = "List of public subnets in the VPC"
  value       = module.vpc.public_subnets
}

/*
output "vpc_database_subnets" {
  description = "List of database subnets in the VPC"
  value       = module.vpc.database_subnets
}
*/

output "nat_public_ips" {
  description = "List of NAT Gateway IDs in the VPC"
  value       = module.vpc.nat_public_ips
}
