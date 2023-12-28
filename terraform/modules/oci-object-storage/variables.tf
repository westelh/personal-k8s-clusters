variable "oci_compartment_id" {
  type = string
  description = "The OCID of the compartment where the bucket will be created."
}

variable "prefix" {
  type = string
  description = "The prefix of the bucket name."
}

variable "access_type" {
  type = string
  description = "The type of access available on this bucket."
  default = "NoPublicAccess"
}

