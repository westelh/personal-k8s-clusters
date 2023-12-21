data "vault_policy_document" "argocd" {
  path         = "kv/data/argocd/*"
  capabilities = ["read"]
  description  = "ArgoCD can insert secrets into the configuration."
}

resource "vault_policy" "argocd" {
  name   = "argocd"
  policy = data.vault_policy_document.argocd.hcl
}
