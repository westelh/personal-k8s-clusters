# Startup
## Enable Kubernetes Auth method
https://developer.hashicorp.com/vault/docs/auth/kubernetes#configuration

### Enable

```
vault auth enable kubernetes
```

### Certificate Authority

```
kubectl get cm --output jsonpath='{.items[0].data.ca\.crt}' > ca.crt
```

### Token Reviewer JWT

```
kubectl create token vault -n vault > sa_vault_token.txt
```

### Configure Auth method

```
vault write auth/kubernetes/config token_reviewer_jwt=@sa_vault_token.txt kubernetes_host="https://kubernetes.default.svc" kubernetes_ca_cert=@ca.crt
```

