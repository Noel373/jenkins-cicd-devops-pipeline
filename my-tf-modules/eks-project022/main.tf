module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.8.5"

  cluster_name    = var.cluster_name
  cluster_version = "1.27"

  vpc_id          = var.vpc_id
  subnet_ids      = var.private_subnet_ids

 eks_managed_node_groups = {
    default = {
      desired_capacity = var.desired_capacity
      max_capacity     = var.max_size
      min_capacity     = var.min_size

      instance_types = [var.node_instance_type]

      # Use private subnets for nodes
      subnet_ids = var.private_subnet_ids
    }
  }

  tags = {
    "Project" = "project022D"
  }

  # Enable IRSA for AWS Load Balancer Controller
  enable_irsa = true

  # Create IAM OIDC provider
  #create_iam_oidc_provider = true
}

# Create IAM policy and service account for ALB Ingress Controller (AWS Load Balancer Controller)
resource "aws_iam_policy" "alb_ingress_controller_policy" {
  name        = "${var.cluster_name}-alb-ingress-policy"
  description = "IAM policy for ALB Ingress Controller"

  policy = file("alb-ingress-iam-policy.json")
}

resource "aws_iam_role_policy_attachment" "alb_ingress_controller_attachment" {
  role       = module.eks.irsa_roles["kube-system"]["aws-load-balancer-controller"]
  policy_arn = aws_iam_policy.alb_ingress_controller_policy.arn
}

