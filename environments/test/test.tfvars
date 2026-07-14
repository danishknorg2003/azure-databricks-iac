# WHAT: Environment-specific variable overrides for "test".
environment                 = "test"
location                    = "eastus"
resource_group_name         = "rg-databricks-test"
vnet_name                   = "vnet-databricks-test"
vnet_address_space          = ["10.20.0.0/16"]
public_subnet_cidr          = "10.20.1.0/24"
private_subnet_cidr         = "10.20.2.0/24"
storage_account_name        = "stdatabrickstestuc01"
storage_container_name      = "unity-catalog-root"
databricks_workspace_name   = "dbw-databricks-test"
databricks_managed_rg_name  = "rg-databricks-test-managed"
access_connector_name       = "ac-databricks-test"
catalog_name                = "test_catalog"
schema_name                 = "default_schema"
table_name                  = "sample_table"
catalog_owner                = "account users"
enable_diagnostic_settings  = false

tags = {
  Environment = "test"
  Owner       = "data-platform-team"
  CostCenter  = "1234"
  Application = "azure-databricks-platform"
}
