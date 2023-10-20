#!/bin/bash
set -e

if [ -z "$1" ]; then
    echo "Server URL argument is empty. Using localhost"
    SERVER_URL="localhost:5443"
else
    echo "Connecting to $1"
    SERVER_URL=$1
fi

argocd app create argocd \
    --server $SERVER_URL \
    --project default \
    --repo https://github.com/westelh/personal-k8s-clusters.git \
    --path apps/argocd \
    --dest-namespace argocd \
    --dest-server https://kubernetes.default.svc  


argocd app create monitoring \
    --server $SERVER_URL \
    --project default \
    --repo https://github.com/westelh/personal-k8s-clusters.git \
    --path apps/monitoring \
    --dest-namespace monitoring \
    --dest-server https://kubernetes.default.svc  