path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

path "consul-ca/cert/ca" {
    capabilities = ["read"]
}

path "consul-ca/issue/connectInjector" {
  capabilities = ["create", "update"]
}
