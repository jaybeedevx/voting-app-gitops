output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "private_subnet_ids" {
  description = "List of private subnet IDs"
  value       = module.vpc.private_subnets
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = module.vpc.public_subnets
}

output "cluster_endpoint" {
  description = "EKS cluster endpoint URL"
  value       = module.eks.cluster_endpoint
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded CA certificate"
  value       = module.eks.cluster_certificate_authority_data
}

output "cluster_oidc_issuer_url" {
  description = "OIDC issuer URL for the cluster"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_name" {
  description = "Full name of the EKS cluster"
  value       = module.eks.cluster_name
}

output "node_group_arn" {
  description = "ARN of the main node group"
  value       = module.eks.eks_managed_node_groups["main"].node_group_arn
}

output "node_iam_role_arn" {
  description = "IAM role ARN attached to worker nodes"
  value       = module.eks.eks_managed_node_groups["main"].iam_role_arn
}