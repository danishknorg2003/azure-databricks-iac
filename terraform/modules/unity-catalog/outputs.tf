output "catalog_name" {
  value = databricks_catalog.this.name
}

output "schema_name" {
  value = databricks_schema.this.name
}

output "table_name" {
  value = databricks_sql_table.this.name
}

output "storage_credential_name" {
  value = databricks_storage_credential.this.name
}

output "external_location_name" {
  value = databricks_external_location.this.name
}
