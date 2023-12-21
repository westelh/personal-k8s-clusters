# PKI Role for Consul Server
resource "vault_pki_secret_backend_role" "consul_server" {
  backend = vault_mount.pki.path
  name    = "consul-server"
  allowed_domains = [
    "lark.consul",
    "consul-server",
    "consul-server.consul",
    "consul-server.consul.svc"
  ]
  allow_bare_domains = true
  allow_subdomains   = true
}

# Policy document for Consul Server
data "vault_policy_document" "consul_server" {
  rule {
    path         = "kv/data/consul/gossip"
    capabilities = ["read"]
    description  = "Read gossip key"
  }
  rule {
    path         = "${vault_pki_secret_backend_role.consul_server.backend}/issue/${vault_pki_secret_backend_role.consul_server.name}"
    capabilities = ["create", "update"]
    description  = "Issue certificates for consul server"
  }
  rule {
    path         = "pki/root/sign-intermediate"
    capabilities = ["update"]
    description  = "Sign intermediate CA"
  }
  rule {
    path         = "${vault_mount.consul_ca.path}/*"
    capabilities = ["create", "update", "read", "delete", "list"]
    description  = "Manage consul-ca intermediate CA"
  }
}

resource "vault_policy" "consul_server" {
  name   = "consul-server"
  policy = data.vault_policy_document.consul_server.hcl
}

resource "vault_kubernetes_auth_backend_role" "consul_server" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "consul-server"
  bound_service_account_names      = ["consul-server"]
  bound_service_account_namespaces = ["consul"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.consul_server.name]
}
