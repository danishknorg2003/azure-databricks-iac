# WHAT: Root module -- wires together every child module into the full Databricks platform.
# WHY : Keeps a clean composition root: each module owns one concern (network, storage,
#       identity, workspace, Unity Catalog) and main.tf only handles wiring + dependencies.
# HOW : module blocks reference outputs from earlier modules; depends_on is used only where
#       Terraform's implicit graph can't infer the relationship (e.g. RBAC propagation before
#       Unity Catalog storage credential creation).

locals {
  common_tags = merge(var.tags, {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "azure-databricks-platform"
  })
}

module "resource_group" {
  source   = "./modules/resource-group"
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

module "network" {
  source              = "./modules/network"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  vnet_name           = var.vnet_name
  vnet_address_space  = var.vnet_address_space
  public_subnet_name  = var.public_subnet_name
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_name = var.private_subnet_name
  private_subnet_cidr = var.private_subnet_cidr
  tags                = local.common_tags
}

module "storage" {
  source               = "./modules/storage"
  resource_group_name  = module.resource_group.name
  location             = module.resource_group.location
  storage_account_name = var.storage_account_name
  container_name       = var.storage_container_name
  tags                 = local.common_tags
}

module "access_connector" {
  source              = "./modules/access-connector"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  name                = var.access_connector_name
  tags                = local.common_tags
}

module "role_assignment" {
  source             = "./modules/role-assignment"
  storage_account_id = module.storage.storage_account_id
  principal_id       = module.access_connector.principal_id
}

module "databricks_workspace" {
  source                      = "./modules/databricks"
  resource_group_name         = module.resource_group.name
  location                    = module.resource_group.location
  workspace_name              = var.databricks_workspace_name
  managed_resource_group_name = var.databricks_managed_rg_name
  vnet_id                     = module.network.vnet_id
  public_subnet_name          = module.network.public_subnet_name
  private_subnet_name         = module.network.private_subnet_name
  tags                        = local.common_tags

  depends_on                                           = [module.network]
  public_subnet_network_security_group_association_id  = module.network.public_subnet_network_security_group_association_id
  private_subnet_network_security_group_association_id = module.network.private_subnet_network_security_group_association_id
}

# Optional diagnostic settings for the Databricks workspace.
resource "azurerm_monitor_diagnostic_setting" "databricks" {
  count                      = var.enable_diagnostic_settings ? 1 : 0
  name                       = "${var.databricks_workspace_name}-diag"
  target_resource_id         = module.databricks_workspace.workspace_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "clusters"
  }
  enabled_log {
    category = "notebook"
  }
  enabled_log {
    category = "jobs"
  }

  metric {
    category = "AllMetrics"
  }
}

module "unity_catalog" {
  source                       = "./modules/unity-catalog"
  access_connector_id          = module.access_connector.id
  storage_account_dfs_endpoint = module.storage.primary_dfs_endpoint
  storage_account_name         = module.storage.storage_account_name
  container_name               = module.storage.container_name
  catalog_name                 = var.catalog_name
  schema_name                  = var.schema_name
  # table_name                   = var.table_name
  catalog_owner = var.catalog_owner

  # Unity Catalog storage credential validation needs the RBAC role assignments to have
  # propagated on the storage account first -- Terraform can't infer this cross-provider
  # dependency automatically, so it's made explicit.
  depends_on = [
    module.role_assignment,
    module.databricks_workspace,
  ]
}
