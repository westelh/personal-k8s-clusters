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

# Roles and Policies
## Consul-Server
| # The Vault role for the Consul server.
| # The role must be connected to the Consul server's service account.
| # The role must also have a policy with read capabilities for the following secrets:
| # - gossip encryption key defined by the `global.gossipEncryption.secretName` value
| # - certificate issue path defined by the `server.serverCert.secretName` value
| # - CA certificate defined by the `global.tls.caCert.secretName` value
| # - replication token defined by the `global.acls.replicationToken.secretName` value if `global.federation.enabled` is `true`

```
vault policy write consul-server vault/policies/consul-server.hcl
```

```
vault write auth/kubernetes/role/consul-server \
    bound_service_account_names=consul-server \
    bound_service_account_namespaces=default \
    policies=consul-server \
    ttl=1h
```

## Consul-Client
| # The Vault role for the Consul client.
| # The role must be connected to the Consul client's service account.
| # The role must also have a policy with read capabilities for the gossip encryption
| # key defined by the `global.gossipEncryption.secretName` value.

```
vault policy write consul-client vault/policies/consul-client.hcl
```

```
vault write auth/kubernetes/role/consul-client \
    bound_service_account_names=consul-client \
    bound_service_account_namespaces=default \
    policies=consul-client \
    ttl=1h
```

## Consul-CA
| # The Vault role for all Consul components to read the Consul's server's CA Certificate (unauthenticated).
| # The role should be connected to the service accounts of all Consul components, or alternatively `*` since it
| # will be used only against the `pki/cert/ca` endpoint which is unauthenticated. A policy must be created which grants
| # read capabilities to `global.tls.caCert.secretName`, which is usually `pki/cert/ca`.

```
vault policy write consul-ca vault/policies/consul-ca.hcl
```

```
vault write auth/kubernetes/role/consul-ca \
    bound_service_account_names=consul-connect-injector,consul-gateway-resources,consul-gateway-cleanup,consul-webhook-cert-manager,consul-server,consul-client,consul-gossip-encryption-autogenerate \
    bound_service_account_namespaces=default \
    policies=consul-ca \
    ttl=1h
```

```
vault write pki/roles/consul-server \
    allowed_domains="kestrel.consul, consul-server, consul-server.default, consul-server.default.svc" \
    allow_subdomains=true \
    allow_bare_domains=true \
    allow_localhost=true \
    max_ttl="720h"
```