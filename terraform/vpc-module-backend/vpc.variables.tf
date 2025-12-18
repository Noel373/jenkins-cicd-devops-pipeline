variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "vpc-project003"    
  
}

# Variables for VPC configuration
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.10.0.0/16"
}

#vpc azs, private and public subnets
variable "vpc_azs" {
  description = "Availability Zones for the VPC"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
}
variable "vpc_private_subnets" {
  description = "Private subnets for the VPC"
  type        = list(string)
  default     = ["10.10.0.0/19", "10.10.32.0/19"]
}
variable "vpc_public_subnets" {
  description = "Public subnets for the VPC"
  type        = list(string)
  default     = ["10.10.64.0/19", "10.10.96.0/19"]
}



# Variables for single NAT Gateway, and VPN Gateway
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateway for outbound internet access from private subnets"
  type        = bool
  default     = true
}
variable "vpc__enable_single_nat_gateway" {
  description = "Use a single NAT Gateway for the VPC"
  type        = bool
  default     = true
}


# Variables for Database Subnet Group and Route Table
variable "vpc_create_database_subnet_group" {
  description = "Create a database subnet group"
  type        = bool
  default     = true
}   
variable "vpc_create_database_subnet_route_table" {
  description = "Create a route table for database subnets"
  type        = bool
  default     = true
}
variable "vpc_database_subnets" {
  description = "Database subnets for the VPC"
  type        = list(string)
  default     = ["10.10.128.0/19", "10.10.160.0/19"]
}