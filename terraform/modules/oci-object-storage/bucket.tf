resource "random_id" "bucket_suffix" {
  byte_length = 8
  prefix      = var.prefix
  keepers = {
    oci_compartment_id = var.oci_compartment_id
  }
}

data "oci_objectstorage_namespace" "namespace" {
  compartment_id = var.oci_compartment_id
}

resource "oci_objectstorage_bucket" "bucket" {
  compartment_id = var.oci_compartment_id
  name = random_id.bucket_suffix.hex
  namespace = data.oci_objectstorage_namespace.namespace.namespace
  access_type = var.access_type
}

