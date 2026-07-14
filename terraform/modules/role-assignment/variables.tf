# WHAT: Variables for the RBAC Role Assignment module.
# WHY : The Access Connector's managed identity needs specific data-plane roles on the
#       storage account to let Unity Catalog read/write/event-subscribe.
# HOW : A map of role assignments is passed in and expanded with for_each.

variable "storage_account_id" {
  description = "Scope (storage account resource ID) for the role assignments."
  type        = string
}

variable "principal_id" {
  description = "Object ID of the Access Connector's managed identity."
  type        = string
}

variable "role_definition_names" {
  description = "List of built-in RBAC role names to assign to the principal at the storage account scope."
  type        = list(string)
  default = [
    "Storage Blob Data Contributor",
    "Storage Queue Data Contributor",
    "Storage Account Contributor",
    "EventGrid EventSubscription Contributor",
  ]
}
