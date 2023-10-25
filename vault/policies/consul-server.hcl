path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

path "kv/data/consul/server" {
    capabilities = [ "read" ]
}

path "kv/data/consul/ca" {
    capabilities = [ "read" ]
}

path "pki/issue/consul-server" {
  capabilities = ["create", "update"]
}