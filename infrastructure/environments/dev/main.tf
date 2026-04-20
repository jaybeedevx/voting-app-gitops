terraform {
  # The backend will be configured after creating the S3 bucket.
  # We use a partial configuration – actual values will be provided
  # via `-backend-config` or in a separate `backend.tfvars`.
  backend "s3" {
    # Leave empty; will be filled during init
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
  # Override instance type for dev to save cost
  node_instance_types = ["t3.micro"]

  tags = {
    CostCenter = "engineering"
    ManagedBy  = "Terraform"
  }
}

# Output the cluster name for convenience
output "cluster_name" {
  value = module.vpc_eks.cluster_name
}