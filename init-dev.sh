#!/bin/bash
set -e

# Listen for user input
read -p "Do you want to delete existing colima instance and create a new one? (y/n)" choice
case "$choice" in
  y|Y )
    # User chose to proceed
    echo "Proceeding with new deployment..."
    # Add your deployment commands here
    colima stop
    colima delete
    rm -f ~/.kube/config
    colima start --kubernetes --memory 16 --cpu 8 --runtime containerd
    ;;
  n|N )
    # User chose not to proceed
    echo "Proceeding with existing deployment..."
    ;;
  * )
    # User entered an invalid choice
    echo "Invalid choice. Exiting script."
    exit 1
    ;;
esac

KUBECONFIG=~/.kube/config

echo "Create namespace if not exists"
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml --wait=true

echo "Port forwarding argocd server"
kubectl port-forward svc/argocd-server -n argocd 5443:443 &

echo "Initial admin password is here."
kubectl -n argocd get secret/argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d

echo "Please login with the password above and update the password."
argocd login localhost:5443
argocd account update-password