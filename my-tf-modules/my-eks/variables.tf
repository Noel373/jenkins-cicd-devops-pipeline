variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "project022-eks"
}

variable "cluster_version" {
  type        = string
  description = "EKS Kubernetes version"
  default     = "1.31"
}

variable "vpc_id" {
  type        = string
  description = "Existing VPC ID to deploy EKS into"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs to use"
}

variable "control_plane_subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for control plane"
}

variable "eks_managed_node_group_defaults" {
  type = object({
    instance_types             = list(string)
    iam_role_additional_policies = map(string)
  })
  default = {
    instance_types             = ["t3.micro"]
    iam_role_additional_policies = {}
  }
}

variable "eks_managed_node_groups" {
  type = map(object({
    ami_type       = optional(string)
    instance_types = list(string)
    min_size      = number
    max_size      = number
    desired_size  = number
    name          = optional(string)
    iam_role_additional_policies = optional(map(string))
  }))
  default = {}
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources"
  default     = {}
}
