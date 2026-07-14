# WHAT: Input variables for the ADLS Gen2 storage module.
# WHY : Unity Catalog needs a hierarchical-namespace storage account + container to act
#       as the metastore/catalog root storage (or external location storage).
# HOW : Standard variables passed from root main.tf.

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "storage_account_name" {
  description = "Globally unique name (lowercase, no dashes, 3-24 chars)."
  type        = string
}

variable "container_name" {
  description = "Name of the blob container used as Unity Catalog external location root."
  type        = string
}

variable "account_tier" {
  type    = string
  default = "Standard"
}

variable "account_replication_type" {
  type    = string
  default = "GRS"
}

variable "tags" {
  type    = map(string)
  default = {}
}
