path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
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
