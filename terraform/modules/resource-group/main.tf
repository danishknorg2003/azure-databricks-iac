# WHAT: Creates the single Resource Group that hosts all Databricks-related infra.
# WHY : Centralizing resources in one RG simplifies RBAC, cost tracking, and lifecycle management.
# HOW : Uses azurerm_resource_group. Tags are merged from the caller for consistent governance.

resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags
}
