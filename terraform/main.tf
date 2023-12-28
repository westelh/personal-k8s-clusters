terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.23.0"
    }
    oci = {
      source  = "hashicorp/oci"
      version = "5.23.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "vault" {
  address = "https://vault.westelh.dev"
}

provider "oci" {
  config_file_profile = "DEFAULT"
}
