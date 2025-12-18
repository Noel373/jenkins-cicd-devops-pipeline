// variables.tf
variable "name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "aws_region" {}
variable "subnet_id" {}
variable "security_group_id" {}
variable "associate_public_ip" {
  type    = bool
  default = false
}
variable "key_name" {}
variable "instance_count" {
  type    = number
  default = 1
  
}