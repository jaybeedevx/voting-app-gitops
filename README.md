# Cloud‑Native GitOps Pipeline: Voting App

This repository implements a complete GitOps workflow for a containerized voting application on AWS EKS.

## Components
- **Terraform** – VPC and EKS cluster as reusable modules.
- **GitHub Actions** – CI pipeline (test, build, scan, push to ECR, update manifests).
- **Argo CD** – GitOps operator syncing from `kubernetes/` folder.

## Structure
See the [folder structure documentation](link-to-docs).

## Quick Start
1. Create infrastructure: `cd infrastructure/environments/dev && terraform apply`
2. Install Argo CD: `./scripts/install-argocd.sh`
3. Configure Argo CD application pointing to this repo's `kubernetes/` folder.
4. Push code changes – CI and GitOps will do the rest.
