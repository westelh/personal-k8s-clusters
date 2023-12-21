data "vault_policy_document" "argocd" {
  rule {
    path         = "kv/data/argocd/*"
    capabilities = ["read"]
    description  = "ArgoCD can insert secrets into the configuration."
  }
}

resource "vault_policy" "argocd" {
  name   = "argocd"
  policy = data.vault_policy_document.argocd.hcl
}

resource "vault_kubernetes_auth_backend_role" "argocd" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "argocd"
  bound_service_account_names      = ["argocd-repo-server"]
  bound_service_account_namespaces = ["argocd"]
  token_ttl                        = 3600
  token_policies                   = [vault_policy.argocd.name]
}
