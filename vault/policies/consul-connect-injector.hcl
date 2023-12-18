path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

path "consul-ca/cert/ca" {
    capabilities = ["read"]
}

path "consul-ca/issuer/default/json" {
    capabilities = ["read"]
}

path "consul-ca/issue/connectInject" {
  capabilities = ["create", "update"]
}
