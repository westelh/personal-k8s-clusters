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

path "pki/root/sign-intermediate" {
  capabilities = ["create", "update"]
}

path "consul-pki/*" {
    capabilities = ["create", "update"]
}

path "consul-pki/roles/*" {
    capabilities = ["create", "update"]
}

path "consul-pki/config/issuers" {
    capabilities = ["read", "update"]
}

path "consul-pki/issuer/*" {
    capabilities = ["read"]
}