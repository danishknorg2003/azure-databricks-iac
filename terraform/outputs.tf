# WHAT: Root-level outputs surfaced after apply.
# WHY : Useful for the pipeline log, downstream automation, and manual verification.
# HOW : Pass-through from child module outputs.

output "resource_group_name" {
  value = module.resource_group.name
}

output "databricks_workspace_url" {
  value = module.databricks_workspace.workspace_url
}

output "databricks_workspace_id" {
  value = module.databricks_workspace.workspace_id
}

output "storage_account_name" {
  value = module.storage.storage_account_name
}

output "access_connector_principal_id" {
  value = module.access_connector.principal_id
}

output "unity_catalog_name" {
  value = module.unity_catalog.catalog_name
}

output "unity_catalog_schema" {
  value = module.unity_catalog.schema_name
}
