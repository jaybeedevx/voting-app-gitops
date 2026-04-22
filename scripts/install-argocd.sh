#!/bin/bash
set -e

echo "Installing Argo CD on EKS cluster..."
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

echo "Waiting for Argo CD pods to be ready..."
kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=argocd-server -n argocd --timeout=300s

echo "Port-forwarding Argo CD server (background)..."
kubectl port-forward svc/argocd-server -n argocd 8080:443 &
echo "Argo CD UI available at https://localhost:8080"

echo "Initial admin password:"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
echo ""
