resource "vault_mount" "consul_ca" {
  path                      = "consul-ca"
  type                      = "pki"
  description               = "Intermediate CA for consul service mesh"
  default_lease_ttl_seconds = 2592000  // 30 days
  max_lease_ttl_seconds     = 31536000 // 1 years
}

resource "vault_pki_secret_backend_config_urls" "consul-ca" {
  backend = vault_mount.consul_ca.path
  issuing_certificates = [
    "${var.vault_addr}/v1/consul-ca/ca",
  ]
  crl_distribution_points = [
    "${var.vault_addr}/v1/consul-ca/crl",
  ]
}

