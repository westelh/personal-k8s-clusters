resource "vault_mount" "pki" {
  path                      = "pki"
  type                      = "pki"
  description               = "PKI secrets engine"
  default_lease_ttl_seconds = 31536000  // 1 years
  max_lease_ttl_seconds     = 315360000 // 10 years
}

resource "vault_pki_secret_backend_config_urls" "pki" {
  backend = vault_mount.pki.path
  issuing_certificates = [
    "${var.vault_addr}/v1/pki/ca",
  ]
  crl_distribution_points = [
    "${var.vault_addr}/v1/pki/crl",
  ]
}

// PKI Root cert was already created manually
// and terraform resource does not support importing
// so is commented out
//resource "vault_pki_secret_backend_root_cert" "pki_root" {
//  backend = vault_mount.pki.path
//  type        = "internal"
//}

