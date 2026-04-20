# ----------------------------------------------------------------------
# VPC Module
# ----------------------------------------------------------------------
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.environment}-vpc"
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs

  enable_nat_gateway     = true
  enable_dns_hostnames   = true
  enable_dns_support     = true
  single_nat_gateway     = true   # cost saving
  one_nat_gateway_per_az = false

  tags = merge(var.tags, {
    Environment = var.environment
    Terraform   = "true"
  })
}

# ----------------------------------------------------------------------
# EKS Cluster + Managed Node Group
# ----------------------------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"   # Use 20.x for stable AL2023 support

  cluster_name    = "${var.environment}-${var.cluster_name}"
  cluster_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Cluster endpoint access (public + private)
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # IAM role for cluster (auto-created)
  create_iam_role = true
  iam_role_name = "${var.environment}-${var.cluster_name}-cluster-role" # This was 'cluster_iam_role_name'

  # Managed node group defaults
  eks_managed_node_group_defaults = {
    ami_type = var.node_ami_type
    tags = {
      Environment = var.environment
    }
  }

  # Node group definition
  eks_managed_node_groups = {
    main = {
      name = "${var.environment}-node-group"

      instance_types = var.node_instance_types

      min_size     = var.node_min_size
      max_size     = var.node_max_size
      desired_size = var.node_desired_size

      subnet_ids = module.vpc.private_subnets

      # IAM role for nodes (auto-created with standard policies)
      create_iam_role = true
      iam_role_name   = "${var.environment}-${var.cluster_name}-node-role"

      # Attach additional policies (e.g., ECR pull, CloudWatch)
      iam_role_additional_policies = {
        AAmazonEC2ContainerRegistryReadOnly = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        CloudWatchAgentServerPolicy       = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
      }

      tags = merge(var.tags, {
        Environment = var.environment
      })
    }
  }

  tags = merge(var.tags, {
    Environment = var.environment
    Terraform   = "true"
  })
}