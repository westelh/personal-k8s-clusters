path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

path "pki/cert/ca" {
    capabilities = ["read"]
}

# Allow consul to get server cert
path "pki_int1/issue/consul-server" {
    capabilities = ["create", "update"]
}

# Allow consul to read the root pki
path "pki" {
    capabilities = ["read"]
}

# Allow consul to sign own ca
path "pki/root/sign-intermediate" {
    capabilities = ["update"]
}

# Full access to the consul ca
path "consul-ca/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
