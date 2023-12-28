data "oci_identity_compartment" "compartment" {
    id = var.oci_compartment_id
}

module "chunks" {
  source = "./modules/oci-object-storage"
  oci_compartment_id = var.oci_compartment_id
  prefix = "lark-loki-chunks-"
}

module "ruler" {
  source = "./modules/oci-object-storage"
  oci_compartment_id = var.oci_compartment_id
  prefix = "lark-loki-ruler-"
}

module "admin" {
  source = "./modules/oci-object-storage"
  oci_compartment_id = var.oci_compartment_id
  prefix = "lark-loki-admin-"
}

resource "oci_identity_group" "loki_instance" {
  compartment_id = var.oci_compartment_id
  description = "Identity Group for the loki instance"
  name = "LokiInstance"
}

resource "oci_identity_policy" "loki-storage-read" {
  compartment_id = var.oci_compartment_id
  description = "Allow read access to the Loki storage buckets"
  name = "loki-storage-read"
  statements = [
    "Allow group ${oci_identity_group.loki_instance.name} to read buckets in tenancy",
    "Allow group ${oci_identity_group.loki_instance.name} to manage objects in tenancy where target.bucket.name='${module.ruler.bucket_name}'",
    "Allow group ${oci_identity_group.loki_instance.name} to manage objects in tenancy where target.bucket.name='${module.chunks.bucket_name}'",
    "Allow group ${oci_identity_group.loki_instance.name} to manage objects in tenancy where target.bucket.name='${module.admin.bucket_name}'"
  ]
}

resource "oci_identity_user" "lark-s3-secret-access" {
  compartment_id = var.oci_compartment_id
  description = "Identity User for the loki instance on lark to access the S3 APIs"
  name = "lark-s3-secret-access"
  email = "nisyumidon@gmail.com"
}

resource "oci_identity_user_group_membership" "lark-s3-secret-access" {
    group_id = oci_identity_group.loki_instance.id
    user_id = oci_identity_user.lark-s3-secret-access.id
}
