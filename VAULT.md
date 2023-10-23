# Startup
## Enable Kubernetes Auth method
https://developer.hashicorp.com/vault/docs/auth/kubernetes#configuration

### Enable

```
vault auth enable kubernetes
```

### Configure Auth method

kubectl exec -it vault-0 /bin/sh

```
vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host=https://kubernetes.default.svc  \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

