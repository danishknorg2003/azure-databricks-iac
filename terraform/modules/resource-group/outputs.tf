# WHAT: Exposes Resource Group attributes for consumption by other modules.
# WHY : Other modules (network, storage, databricks) need the RG name/location/id.
# HOW : Simple pass-through outputs.

output "name" {
  value = azurerm_resource_group.this.name
}

output "location" {
  value = azurerm_resource_group.this.location
}

output "id" {
  value = azurerm_resource_group.this.id
}
