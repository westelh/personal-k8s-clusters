data "vault_policy_document" "vault_issuer" {
  rule {
    path         = "pki_int1/sign/westelh-dev"
    capabilities = ["create", "update"]
    description  = "Vault Issuer can sign certificates for westelh.dev domain."
  }
}

resource "vault_policy" "vault_issuer" {
  name   = "vault-issuer"
  policy = data.vault_policy_document.vault_issuer.hcl
}

resource "vault_kubernetes_auth_backend_role" "vault_issuer" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "vault-issuer"
  bound_service_account_names      = ["vault-issuer"]
  bound_service_account_namespaces = ["*"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.vault_issuer.name]
  audience                         = "vault"
}
