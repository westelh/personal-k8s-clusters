resource "vault_pki_secret_backend_role" "connect_injector" {
  backend = vault_mount.pki.path
  name    = "connectInjector"
  allowed_domains = [
    "consul-connect-injector",
    "consul-connect-injector.consul",
    "consul-connect-injector.consul.svc",
    "consul-connect-injector.consul.svc.cluster.local"
  ]
  allow_bare_domains = true
  allow_subdomains   = true
}

data "vault_policy_document" "consul_connect_injector" {
  rule {
    path         = "pki/issue/connectInjector"
    capabilities = ["create", "update"]
    description  = "Allow consul connect injector to issue certificates"
  }
  rule {
    path         = "pki/cert/ca"
    capabilities = ["read"]
    description  = "Allow consul connect injector to read CA certificate"
  }
}

resource "vault_policy" "consul_connect_injector" {
  name   = "consul-connect-injector"
  policy = data.vault_policy_document.consul_connect_injector.hcl
}

resource "vault_kubernetes_auth_backend_role" "consul_connect_injector" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "consul-connect-injector"
  bound_service_account_names      = ["consul-connect-injector"]
  bound_service_account_namespaces = ["consul"]
  token_policies                   = ["consul-connect-injector"]
  token_ttl                        = 3600
}
