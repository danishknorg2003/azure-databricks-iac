# WHAT: Azure Databricks Access Connector with a system-assigned managed identity.
# WHY : Unity Catalog storage credentials reference this identity instead of a service
#       principal secret, satisfying the "Managed Identity, not SP secret" requirement.
# HOW : azurerm_databricks_access_connector with identity block type = "SystemAssigned".

resource "azurerm_databricks_access_connector" "this" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  identity {
    type = "SystemAssigned"
  }
}
