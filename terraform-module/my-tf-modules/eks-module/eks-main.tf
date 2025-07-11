module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.31"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  cluster_security_group_name = "project017-cluster-sg"
  eks_managed_node_groups = {
    general-purpose = {
      desired_capacity = var.general_purpose_desired_capacity
      max_capacity     = var.general_purpose_max_capacity
      min_capacity     = var.general_purpose_min_capacity

      instance_type = var.general_purpose_instance_type
      key_name      = var.general_purpose_key_name

      tags = {
        Name = "general-purpose-node-group"
      }
    }
  }

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}