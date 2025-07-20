module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access           = true

  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_group_defaults = {
    instance_types = var.eks_managed_node_group_defaults.instance_types
    iam_role_additional_policies = length(var.eks_managed_node_group_defaults.iam_role_additional_policies) > 0 ? var.eks_managed_node_group_defaults.iam_role_additional_policies : tomap({})
  }

  eks_managed_node_groups = {
    for key, val in var.eks_managed_node_groups : key => {
      ami_type       = lookup(val, "ami_type", null)
      instance_types = val.instance_types
      min_size       = val.min_size
      max_size       = val.max_size
      desired_size   = val.desired_size
      name           = lookup(val, "name", null)
      iam_role_additional_policies = lookup(val, "iam_role_additional_policies", tomap({}))
    }
  }

  tags = var.tags
}
