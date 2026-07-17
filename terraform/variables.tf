# WHAT: Root module input variables.
# WHY : Single source of truth for all configurable values; enables the same codebase to be
#       reused for dev/test/prod via -var-file per environment.
# HOW : Typed variables with validation blocks and sensible defaults where safe.

variable "environment" {
  description = "Deployment environment identifier."
  type        = string
  validation {
    condition     = contains(["dev", "test", "prod"], var.environment)
    error_message = "environment must be one of: dev, test, prod."
  }
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  type = string
}

variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}

variable "public_subnet_name" {
  type    = string
  default = "snet-databricks-public"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.10.1.0/24"
}

variable "private_subnet_name" {
  type    = string
  default = "snet-databricks-private"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.10.2.0/24"
}

variable "storage_account_name" {
  description = "Globally unique, lowercase, 3-24 alphanumeric characters."
  type        = string
}

variable "storage_container_name" {
  type    = string
  default = "unity-catalog-root"
}

variable "databricks_workspace_name" {
  type = string
}

variable "databricks_managed_rg_name" {
  type = string
}

variable "access_connector_name" {
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
  description = "Account-level user/group/service principal that owns the catalog (e.g. an Azure AD group)."
  type        = string
}

variable "enable_diagnostic_settings" {
  description = "Whether to enable diagnostic settings on the workspace (optional per spec)."
  type        = bool
  default     = false
}

variable "log_analytics_workspace_id" {
  description = "Required only when enable_diagnostic_settings = true."
  type        = string
  default     = null
}

variable "tags" {
  description = "Common tags applied to all resources."
  type        = map(string)
  default     = {}
}
