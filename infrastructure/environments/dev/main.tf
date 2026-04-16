terraform {
  backend "s3" {
    # Will be configured after creating S3 bucket
  }
}

module "vpc_eks" {
  source = "../../modules/vpc-eks"

  environment       = "dev"
  aws_region        = "us-east-1"
  cluster_name      = "voting-app"
  node_desired_size = 2
  node_min_size     = 2
  node_max_size     = 4
}

output "cluster_name" {
  value = module.vpc_eks.cluster_name
}