output "id" {
  value = azurerm_databricks_access_connector.this.id
}

output "principal_id" {
  description = "Object ID of the system-assigned managed identity, used for RBAC role assignments."
  value       = azurerm_databricks_access_connector.this.identity[0].principal_id
}
