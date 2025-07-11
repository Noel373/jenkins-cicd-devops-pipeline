variable "instance_type" {
  description = "Type of EC2 instance to launch"
  type        = string
  default     = "t2.micro"  
  
}
variable "key_name" {
  description = "Name of the SSH key pair to use for the instance"
  type        = string
  default     = "my-key-pair"  # Change to your key pair name
}
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-020cba7c55df1f615"  # Change to your preferred AMI ID
}
variable "availability_zone" {
  description = "Availability zone for the EC2 instance"
  type        = string
  default     = "us-east-1a"  # Change to your preferred availability zone
}
variable "instance_name" {
  description = "Name tag for the EC2 instance"
  type        = string
  default     = "jenkins-server"  # Change to your preferred instance name
}
variable "environment" {
  description = "Environment tag for the EC2 instance"
  type        = string
  default     = "development"  # Change to your preferred environment  
  
}