# --------------------------------------------------
# VPC Module
# --------------------------------------------------
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
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = merge(var.tags, {
    Environment = var.environment
    Terraform   = "true"
  })
}

# --------------------------------------------------
# EKS Cluster & Node Group
# --------------------------------------------------
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.environment}-${var.cluster_name}"
  cluster_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Cluster endpoint access
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  # Managed node group(s)
  eks_managed_node_groups = {
    main = {
      name           = "${var.environment}-node-group"
      instance_types = var.node_instance_types
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      desired_size   = var.node_desired_size

      subnet_ids = module.vpc.private_subnets

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

# --------------------------------------------------
# (Optional) Security group rules for additional access
# --------------------------------------------------
resource "aws_security_group_rule" "allow_https_from_anywhere" {
  count = var.environment == "dev" ? 1 : 0   # only open in dev

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.eks.cluster_primary_security_group_id
}