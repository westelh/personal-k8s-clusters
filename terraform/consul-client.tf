data "vault_policy_document" "consul_client" {
  rule {
    path = "kv/data/consul/gossip"
    capabilities = ["read"]
    description = "Consul client can read gossip key"
  }
}

resource "vault_policy" "consul_client" {
  name = "consul-client"
  policy = data.vault_policy_document.consul_client.hcl
}

