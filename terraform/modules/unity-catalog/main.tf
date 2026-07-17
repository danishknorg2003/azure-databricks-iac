# WHAT: Full Unity Catalog object chain: Storage Credential -> External Location -> Catalog ->
#       Schema -> Sample Table -> Grants.
# WHY : This is the metadata/governance layer Databricks uses to map ADLS Gen2 storage into a
#       catalog structure with fine-grained, centrally managed access control.
# HOW : Uses the `databricks` provider (aliased to the workspace via provider config in root).
#       The storage credential references the Access Connector's managed identity -- never a
#       service principal client secret.

# 1. Storage Credential backed by the Access Connector's system-assigned managed identity.
resource "databricks_storage_credential" "this" {
  name = var.storage_credential_name

  azure_managed_identity {
    access_connector_id = var.access_connector_id
  }

  comment = "Managed-identity-based storage credential (no SP secrets), provisioned by Terraform."
}

# 2. External Location pointing at the ADLS Gen2 container, using the credential above.
resource "databricks_external_location" "this" {
  name            = var.external_location_name
  url             = "abfss://${var.container_name}@${var.storage_account_name}.dfs.core.windows.net/"
  credential_name = databricks_storage_credential.this.id

  comment = "External location for Unity Catalog root storage, provisioned by Terraform."

  depends_on = [databricks_storage_credential.this]
}

# 3. Catalog rooted at the external location.
resource "databricks_catalog" "this" {
  name         = var.catalog_name
  comment      = "Primary catalog provisioned by Terraform."
  storage_root = databricks_external_location.this.url
  owner        = var.catalog_owner

  depends_on = [databricks_external_location.this]
}

# 4. Schema within the catalog.
resource "databricks_schema" "this" {
  catalog_name = databricks_catalog.this.id
  name         = var.schema_name
  comment      = "Default schema provisioned by Terraform."
}

# 5. Sample managed table (Delta) to validate end-to-end read/write.
# resource "databricks_sql_table" "this" {
#   name               = var.table_name
#   catalog_name       = databricks_catalog.this.id
#   schema_name        = databricks_schema.this.name
#   table_type         = "MANAGED"
#   data_source_format = "DELTA"

#   column {
#     name = "id"
#     type = "BIGINT"
#   }

#   column {
#     name = "created_at"
#     type = "TIMESTAMP"
#   }

#   comment = "Sample table created by Terraform to validate Unity Catalog end-to-end."
# }

# 6. Grants -- dynamic block driven by a map so principals/privileges are fully data-driven.
resource "databricks_grants" "catalog" {
  catalog = databricks_catalog.this.id

  dynamic "grant" {
    for_each = var.grant_principals
    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}
