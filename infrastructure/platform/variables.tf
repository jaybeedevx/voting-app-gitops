variable "cluster_name" {
  description = "Name of the existing EKS cluster"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster is deployed"
  type        = string
}