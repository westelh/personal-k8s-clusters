terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.23.0"
    }
  }
}

provider "vault" {
  address = "https://vault.westelh.dev"
}
