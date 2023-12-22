data "vault_policy_document" "consul_client" {
  rule {
    path = "kv/data/consul/gossip"
    capabilities = ["read"]
    description = "Consul client can read gossip key"
  }
  rule {
    path = "pki/cert/ca"
    capabilities = ["read"]
    description = "Consul client can read CA cert"
  }
}

resource "vault_policy" "consul_client" {
  name = "consul-client"
  policy = data.vault_policy_document.consul_client.hcl
}

