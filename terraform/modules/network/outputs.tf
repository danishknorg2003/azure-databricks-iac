# WHAT: Outputs consumed by the Databricks module for VNet injection.
# WHY : azurerm_databricks_workspace requires vnet id + public/private subnet names.
# HOW : Direct references into the resources created above.

output "vnet_id" {
  value = azurerm_virtual_network.this.id
}

output "vnet_name" {
  value = azurerm_virtual_network.this.name
}

output "public_subnet_name" {
  value = azurerm_subnet.this["public"].name
}

output "private_subnet_name" {
  value = azurerm_subnet.this["private"].name
}

output "public_subnet_id" {
  value = azurerm_subnet.this["public"].id
}

output "private_subnet_id" {
  value = azurerm_subnet.this["private"].id
}

output "nsg_id" {
  value = azurerm_network_security_group.this.id
}

output "public_subnet_network_security_group_association_id" {
  value = azurerm_subnet_network_security_group_association.this["public"].id
}

output "private_subnet_network_security_group_association_id" {
  value = azurerm_subnet_network_security_group_association.this["private"].id
}
