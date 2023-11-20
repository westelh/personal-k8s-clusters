# Startup
## Enable Kubernetes Auth method
https://developer.hashicorp.com/vault/docs/auth/kubernetes#configuration

### Enable

```
vault auth enable kubernetes
```

### Configure Auth method from inside vault container
```
kubectl -n vault exec -it vault-0 -- /bin/sh
```

```
vault write auth/kubernetes/config \
    token_reviewer_jwt="$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)" \
    kubernetes_host=https://kubernetes.default.svc  \
    kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt
```

# Cert-Manager

https://cert-manager.io/docs/configuration/vault/

```
kubectl create serviceaccount -n cert-manager vault-issuer
```

Then add an RBAC Role so that cert-manager can get tokens for the ServiceAccount:

```
kubectl apply -n vault -f clusters/dev/manifests/rbac-vault-issuer.yaml
```

Enable PKI,

https://developer.hashicorp.com/vault/docs/secrets/pki/setup

Configure PKI Role, 

https://developer.hashicorp.com/vault/api-docs/secret/pki#create-update-role

```
vault write pki_int1/roles/vault-issuer \
      issuer_ref=default \
      max_ttl=720h \
      allow_any_name=true \
      key_type=any
```

Configure Role,

```
vault write auth/kubernetes/role/vault-issuer \
    bound_service_account_names=vault-issuer \
    bound_service_account_namespaces=cert-manager \
    audience="vault://vault-issuer" \
    policies=vault-issuer \
    ttl=1m
```

Apply policy,

```
vault policy write vault-issuer vault/policies/vault-issuer.hcl 
```

Finally, create the Issuer resource:

```
kubectl apply -f clusters/dev/manifests/
```



# Roles and Policies

## Consul

### Gossip-Key

Enable KV

```
vault secrets enable -version=2 kv
```

Store Key

```
vault kv put kv/consul/gossip key="$(consul keygen)"
```

### Consul-Server
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

### Consul-Client
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

### Consul-CA
| # The Vault role for all Consul components to read the Consul's server's CA Certificate (unauthenticated).
| # The role should be connected to the service accounts of all Consul components, or alternatively `*` since it
| # will be used only against the `pki/cert/ca` endpoint which is unauthenticated. A policy must be created which grants
| # read capabilities to `global.tls.caCert.secretName`, which is usually `pki/cert/ca`.

```
vault policy write consul-ca vault/policies/consul-ca.hcl
```

```
vault write auth/kubernetes/role/consul-ca \
    bound_service_account_names="*" \
    bound_service_account_namespaces=default \
    policies=consul-ca \
    ttl=1h
```

#### Dev
```
vault write pki/roles/consul-server \
    issuer_ref="devroot" \
    allowed_domains="dev.consul, consul-server, consul-server.default, consul-server.default.svc" \
    allow_subdomains=true \
    allow_bare_domains=true \
    allow_localhost=true \
    max_ttl="720h"
```

#### Prod
```
vault write pki/roles/consul-server \
    allowed_domains="kestrel.consul, consul-server, consul-server.default, consul-server.default.svc" \
    allow_subdomains=true \
    allow_bare_domains=true \
    allow_localhost=true \
    max_ttl="720h"
```

#### Certificate Secret
```
pbpaste > consul-ca.crt
kubectl create secret generic consul-vault-ca --from-file vault.ca=consul-ca.crt
```

### Consul-Connect-Injector

```
vault policy write consul-connect-injector vault/policies/consul-connect-injector.hcl
```

```
vault write auth/kubernetes/role/consul-connect-injector \
    bound_service_account_names=consul-connect-injector \
    bound_service_account_namespaces=default \
    policies=consul-connect-injector \
    ttl=1h
```

```
vault write pki/roles/consul-connect-injector \
    allowed_domains="consul-connect-injector,consul-connect-injector.default,consul-connect-injector.default.svc,consul-connect-injector.default.svc.cluster.local" \
    allow_subdomains=true \
    allow_bare_domains=true \
    allow_localhost=true \
    max_ttl="720h"
```

# PKI

Enable PKI

```
vault enable pki
```

PKI can lease certificate for 10 years

```
vault secrets tune -max-lease-ttl=87600h pki
```

## Root

Generate key and enable issuer

```
vault write pki/root/generate/internal \
    common_name=vault.kestrel.westelh.dev \
    ttl=87600h \
    issuer_name=root
```

Set parameters

default

```
vault write pki/config/issuers default="root"
```

crls

```
vault write pki/config/urls \
    issuing_certificates="https://vault.kestrel.westelh.dev/v1/pki/ca" \
    crl_distribution_points="https://vault.kestrel.westelh.dev/v1/pki/crl"
```

Configure roles

```
vault write pki/roles/intermediate \
    allowed_domains=kestrel.westelh.dev \
    allow_subdomains=true \
    max_ttl=43800h
```

## Intermediate

Enable it,

```
vault secrets enable -path=pki_int1 pki
```

Tune it,

```
vault secrets tune -max-lease-ttl=43800h pki
```

Generate intermediate key

```
vault write pki_int1/intermediate/generate/internal \
	common_name="int1.vault.kestrel.westelh.dev" \
	ttl=43800h -format=json | jq .data.csr -r > pki_int1.csr
```

Sign it with root

```
vault write pki/issuer/root/sign-intermediate csr=@pki_int1.csr format=pem_bundle ttl=43800 -format=json | jq -r ".data.certificate" > int.cert.pem
```

Set it as intermediate signing cert

```
vault write pki_int1/intermediate/set-signed certificate=@int.cert.pem
```

crls

```
vault write pki_int1/config/urls \
    issuing_certificates="https://vault.kestrel.westelh.dev/v1/pki_int1/ca" \
    crl_distribution_points="https://vault.kestrel.westelh.dev/v1/pki_int1/crl"
```



