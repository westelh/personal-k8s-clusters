# Gossip encryption is enabled
path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

# Consul Server is secured by /pki
path "pki/cert/ca" {
    capabilities = ["read"]
}
path "pki/issue/consul-server" {
    capabilities = ["create", "update"]
}

# Allow consul to get own intermediate pki signed
path "pki/root/sign-intermediate" {
    capabilities = ["update"]
}

# Full access to the consul ca
path "consul-ca/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
