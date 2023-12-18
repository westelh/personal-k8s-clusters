# Gossip encryption is enabled
path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

# Connect injector needs CA chain to verify service mesh connections
path "consul-ca/issuer/default/json" {
    capabilities = ["read"]
}

# Connect injector needs to issue own tls certificates
path "consul-ca/issue/connectInject" {
  capabilities = ["create", "update"]
}
