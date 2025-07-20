variable "region" {
  description = "AWS region"
  default     = "eu-north-1"
}

variable "name" {
  description = "Prefix name for resources"
  default     = "demo"
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name for EC2"
  type        = string
}
