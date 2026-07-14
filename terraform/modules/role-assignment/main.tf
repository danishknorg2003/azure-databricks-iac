# WHAT: Assigns the four required built-in roles to the Access Connector's managed identity.
# WHY : Storage Blob/Queue Data Contributor allow Unity Catalog data I/O; Storage Account
#       Contributor allows management operations; EventGrid EventSubscription Contributor
#       supports Databricks' file-notification/Auto Loader event-based ingestion.
# HOW : for_each over the role list converts a list into a set to avoid index-based diffs,
#       one azurerm_role_assignment per role, scoped to the storage account.

resource "azurerm_role_assignment" "this" {
  for_each             = toset(var.role_definition_names)
  scope                = var.storage_account_id
  role_definition_name = each.value
  principal_id         = var.principal_id
}
