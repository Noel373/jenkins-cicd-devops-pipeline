variable "vpc_id" {
  description = "VPC ID to launch instances"
  type        = string
}

variable "public_subnet_id" {
  description = "Public subnet for the instances"
  type        = string
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  type        = string
}

variable "key_name" {
  description = "Name of the existing EC2 key pair"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "ssh_allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "List of CIDRs allowed to SSH"
}

variable "api_server_access_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDRs allowed to access Kubernetes API"
}

variable "nodeport_allowed_cidrs" {
  type        = list(string)
  default     = ["0.0.0.0/0"]
  description = "CIDRs allowed to access NodePorts"
}
