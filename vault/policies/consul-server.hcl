# Gossip encryption is enabled
path "kv/data/consul/gossip" {
    capabilities = [ "read" ]
}

# Allow consul to get own intermediate pki signed
path "pki/root/sign-intermediate" {
    capabilities = ["update"]
}

# Full access to the consul ca
path "consul-ca/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
