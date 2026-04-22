terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

module "vpc_eks" {
  source = "../../modules/vpc-eks"

  # Environment identifier
  environment = "prod"

  # AWS region – for prod you might use multiple regions, but here single region
  aws_region = var.aws_region

  # Override CIDR if needed (e.g., larger VPC)
  vpc_cidr = "10.0.0.0/16"

  # Use all available AZs in the region (at least 3 for high availability)
  availability_zones   = var.availability_zones
  private_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnet_cidrs  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  # Production‑grade cluster
  cluster_name       = "voting-app"
  kubernetes_version = var.kubernetes_version

  # Larger instance types for workload
  node_instance_types = var.node_instance_types
  node_desired_size   = var.node_desired_size
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size

  # Production tagging for cost allocation
  tags = {
    Environment = "production"
    CostCenter  = "fintech-platform"
    ManagedBy   = "Terraform"
    Team        = "platform-engineering"
    Backup      = "daily"
  }
}

# Output for CI/CD and Argo CD setup
output "cluster_name" {
  value = module.vpc_eks.cluster_name
}

output "cluster_endpoint" {
  value     = module.vpc_eks.cluster_endpoint
  sensitive = true
}