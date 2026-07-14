# WHAT: Variables for the Azure Databricks Workspace module.
# WHY : Encapsulates all workspace-level configuration (Premium SKU, VNet injection,
#       No Public IP / Secure Cluster Connectivity, managed RG, Unity Catalog).
# HOW : Values are supplied by the root module, largely sourced from the network module outputs.

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "workspace_name" {
  type = string
}

variable "managed_resource_group_name" {
  description = "Name of the Databricks-managed resource group (holds cluster NICs, managed disks, etc.)."
  type        = string
}

variable "vnet_id" {
  type = string
}

variable "public_subnet_name" {
  type = string
}

variable "private_subnet_name" {
  type = string
}

variable "sku" {
  type    = string
  default = "premium" # Required for Unity Catalog + Secure Cluster Connectivity + Conditional Access
}

variable "tags" {
  type    = map(string)
  default = {}
}
