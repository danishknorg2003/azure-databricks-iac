# WHAT: Variables for the Unity Catalog configuration module.
# WHY : Configures storage credential, external location, catalog, schema, sample table,
#       and grants -- all via the Databricks Terraform Provider, using the Access Connector's
#       managed identity (no SP secrets).
# HOW : Passed in from root, sourced from access-connector / storage / databricks module outputs.

variable "access_connector_id" {
  description = "Resource ID of the Azure Databricks Access Connector."
  type        = string
}

variable "storage_credential_name" {
  type    = string
  default = "uc-storage-credential"
}

variable "external_location_name" {
  type    = string
  default = "uc-external-location"
}

variable "storage_account_dfs_endpoint" {
  description = "Primary DFS endpoint of the ADLS Gen2 storage account, e.g. https://<acct>.dfs.core.windows.net."
  type        = string
}

variable "container_name" {
  type = string
}

variable "storage_account_name" {
  type = string
}

variable "catalog_name" {
  type    = string
  default = "main_catalog"
}

variable "schema_name" {
  type    = string
  default = "default_schema"
}

# variable "table_name" {
#   type    = string
#   default = "sample_table"
# }

variable "catalog_owner" {
  description = "Principal (user, group, or service principal) that owns the catalog."
  type        = string
}

variable "grant_principals" {
  description = "Map of principal -> list of privileges to grant on the catalog."
  type        = map(list(string))
  default = {
    "account users" = ["USE_CATALOG", "USE_SCHEMA"]
  }
}
