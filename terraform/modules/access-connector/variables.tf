# WHAT: Variables for the Databricks Access Connector module.
# WHY : The Access Connector is a system/user-assigned managed identity that Unity Catalog
#       uses to authenticate to ADLS Gen2 -- no service principal secrets required.
# HOW : Passed from root module.

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "name" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}
