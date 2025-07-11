variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
    default     = "project017-eks-cluster"
  
}
variable "cluster_version" {
  description = "The Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.31"
}



# Variables for EKS Node Groups
# These variables are used to configure the EKS node groups, specifically for the general purpose node
variable "general_purpose_desired_capacity" {
  description = "Desired capacity for the general purpose node group"
  type        = number
  default     = 2
}
variable "general_purpose_max_capacity" {
  description = "Maximum capacity for the general purpose node group"
  type        = number
  default     = 3
}
variable "general_purpose_min_capacity" {
  description = "Minimum capacity for the general purpose node group"
  type        = number
  default     = 1
}
variable "general_purpose_instance_type" {
  description = "Instance type for the general purpose node group"
  type        = string
  default     = "t3.medium"
}
variable "general_purpose_key_name" {
  description = "Key name for the general purpose node group"
  type        = string
  default     = "my-key-pair"
}



# Variables for VPC and Subnets
# These variables are used to configure the VPC and subnets for the EKS cluster.
variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
  type        = string
  #default     = data.terraform_remote_state.vpc.outputs.vpc_id
}
variable "subnet_ids" {
  description = "List of subnet IDs for the EKS cluster"
  type        = list(string)
  default     = ["10.10.0.0/19", "10.10.32.0/19"]
}