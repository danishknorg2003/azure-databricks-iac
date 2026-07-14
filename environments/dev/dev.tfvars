# WHAT: Environment-specific variable overrides for "dev".
# WHY : Allows the same Terraform codebase to deploy isolated dev infrastructure.
# HOW : Passed to the pipeline via -var-file=environments/dev/dev.tfvars

environment                 = "dev"
location                    = "centralindia"
resource_group_name         = "rg-databricks-dev"
vnet_name                   = "vnet-databricks-dev"
vnet_address_space          = ["10.10.0.0/16"]
public_subnet_cidr          = "10.10.1.0/24"
private_subnet_cidr         = "10.10.2.0/24"
storage_account_name        = "stdatabricksdevuc01"
storage_container_name      = "unity-catalog-root"
databricks_workspace_name   = "dbw-databricks-dev"
databricks_managed_rg_name  = "rg-databricks-dev-managed"
access_connector_name       = "ac-databricks-dev"
catalog_name                = "dev_catalog"
schema_name                 = "default_schema"
table_name                  = "sample_table"
catalog_owner                = "account users"
enable_diagnostic_settings  = false

tags = {
  Environment = "dev"
  Owner       = "data-platform-team"
  CostCenter  = "1234"
  Application = "azure-databricks-platform"
}
