# WHAT: Environment-specific variable overrides for "prod".
environment                = "prod"
location                   = "centralindia"
resource_group_name        = "rg-databricks-prod"
vnet_name                  = "vnet-databricks-prod"
vnet_address_space         = ["10.30.0.0/16"]
public_subnet_cidr         = "10.30.1.0/24"
private_subnet_cidr        = "10.30.2.0/24"
storage_account_name       = "stdatabricksproduc01"
storage_container_name     = "unity-catalog-root"
databricks_workspace_name  = "dbw-databricks-prod"
databricks_managed_rg_name = "rg-databricks-prod-managed"
access_connector_name      = "ac-databricks-prod"
catalog_name               = "prod_catalog"
schema_name                = "default_schema"
table_name                 = "sample_table"
catalog_owner              = "account users"
enable_diagnostic_settings = true

tags = {
  Environment = "prod"
  Owner       = "data-platform-team"
  CostCenter  = "1234"
  Application = "azure-databricks-platform"
}
