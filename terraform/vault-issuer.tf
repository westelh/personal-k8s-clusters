data "vault_policy_document" "vault_issuer" {
  path         = "pki_int1/sign/westelh-dev"
  capabilities = ["create", "update"]
  description  = "Vault Issuer can sign certificates for westelh.dev domain."
}
