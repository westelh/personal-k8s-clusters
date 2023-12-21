# Gossip encryption is enabled
path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

# Connect injector is secured by /pki
path "pki/cert/ca" {
  capabilities = ["read"]
}
path "pki/issue/connectInjector" {
  capabilities = ["create", "update"]
}
