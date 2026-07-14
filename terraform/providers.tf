# WHAT: Provider configuration blocks for azurerm and databricks.
# WHY : azurerm manages Azure infra; the databricks provider (in "azure" auth mode) configures
#       Unity Catalog objects inside the workspace we just created. Both use Managed
#       Identity / Azure AD auth -- no client secrets committed to code or variables.
# HOW : azurerm uses standard ARM auth (via the DevOps service connection / OIDC in the pipeline).
#       databricks provider authenticates against the workspace URL using Azure CLI / Managed
#       Identity auth (auth_type = "azure-cli" locally, or MSI when running from an Azure DevOps
#       agent with a federated/managed identity service connection).

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
  # subscription_id / tenant_id are supplied via ARM_* environment variables set by the
  # AzureCLI@2 / AzureRM service connection task in the pipeline -- never hardcoded here.
}

provider "databricks" {
  host = module.databricks_workspace.workspace_url
  # No token/secret is configured here. The provider auto-detects Azure AD credentials
  # (Managed Identity on the DevOps agent, or `az login` locally) — satisfying the
  # "Managed Identity, not Service Principal secret" requirement.
}
