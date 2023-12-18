path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

path "pki/cert/ca" {
    capabilities = ["read"]
}

path "pki_int1/issuer/consul-server" {
  capabilities = ["update"]
}


path "pki_int1/issue/consul-server" {
    capabilities = ["create", "update"]
}

