#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Server URL argument is empty. Using localhost"
    SERVER_URL="localhost:5443"
else
    echo "Connecting to $1"
    SERVER_URL=$1
fi

echo "Enter \"prod\" or \"dev\" to select the staging environment"
read ENVIRONMENT
# Check if the user entered a valid environment
if [ "$ENVIRONMENT" != "prod" ] && [ "$ENVIRONMENT" != "dev" ]; then
    echo "Invalid environment. Exiting"
    exit 1
fi

argocd app create argocd \
    --server $SERVER_URL \
    --project default \
    --repo https://github.com/westelh/personal-k8s-clusters.git \
    --path apps/argocd/overlays/$ENVIRONMENT \
    --dest-namespace argocd \
    --dest-server https://kubernetes.default.svc  


argocd app create monitoring \
    --server $SERVER_URL \
    --project default \
    --repo https://github.com/westelh/personal-k8s-clusters.git \
    --path apps/monitoring \
    --dest-namespace default \
    --dest-server https://kubernetes.default.svc  

argocd app create service-discovery \
    --server $SERVER_URL \
    --project default \
    --repo https://github.com/westelh/personal-k8s-clusters.git \
    --path apps/service-discovery \
    --dest-namespace default \
    --dest-server https://kubernetes.default.svc  