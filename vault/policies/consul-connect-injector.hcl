path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

path "pki/cert/ca" {
    capabilities = ["read"]
}

path "pki/issue/consul-connect-injector" {
  capabilities = ["create", "update"]
}
