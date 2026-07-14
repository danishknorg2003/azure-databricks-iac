# WHAT: Virtual Network, two delegated subnets, NSGs, and NSG associations for Databricks VNet injection.
# WHY : Azure Databricks requires "public" (host) and "private" (container) subnets, each delegated
#       to Microsoft.Databricks/workspaces, with NSGs attached and rules managed by the platform.
# HOW : azurerm_virtual_network + azurerm_subnet (with delegation blocks) + azurerm_network_security_group
#       + azurerm_subnet_network_security_group_association. for_each is used so the same module can
#       express both subnets without code duplication.

resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.vnet_address_space
  tags                = var.tags
}

# Single NSG shared by both subnets (Databricks manages required rules automatically
# through the "NC" / no-public-IP secure cluster connectivity model).
resource "azurerm_network_security_group" "this" {
  name                = "${var.vnet_name}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

locals {
  subnets = {
    public = {
      name             = var.public_subnet_name
      address_prefixes = [var.public_subnet_cidr]
    }
    private = {
      name             = var.private_subnet_name
      address_prefixes = [var.private_subnet_cidr]
    }
  }
}

resource "azurerm_subnet" "this" {
  for_each             = local.subnets
  name                 = each.value.name
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = each.value.address_prefixes

  delegation {
    name = "databricks-delegation"
    service_delegation {
      name = "Microsoft.Databricks/workspaces"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
        "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
        "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action",
      ]
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "this" {
  for_each                  = azurerm_subnet.this
  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.this.id

  # Ensures the NSG rules Databricks needs are attached before the workspace tries to use the subnets.
  depends_on = [azurerm_network_security_group.this]
}
