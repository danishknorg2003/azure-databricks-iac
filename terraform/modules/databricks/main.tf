# WHAT: Azure Databricks Premium Workspace with VNet injection and No Public IP (Secure Cluster
#       Connectivity), plus a managed resource group.
# WHY : No Public IP removes public IPs from cluster nodes (all traffic stays private/via NAT);
#       VNet injection lets the workspace live in our own VNet/subnets for network control;
#       Premium SKU is required for Unity Catalog and Azure AD Conditional Access.
# HOW : azurerm_databricks_workspace with custom_parameters block referencing the network module's
#       subnet names/ids. The managed RG is created implicitly by Databricks; we only supply its name.

resource "azurerm_databricks_workspace" "this" {
  name                        = var.workspace_name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  sku                         = var.sku
  managed_resource_group_name = var.managed_resource_group_name

  custom_parameters {
    no_public_ip        = true
    virtual_network_id  = var.vnet_id
    public_subnet_name  = var.public_subnet_name
    private_subnet_name = var.private_subnet_name
  }

  tags = var.tags

  lifecycle {
    # Custom parameters are immutable after creation; prevent accidental destructive replace plans.
    ignore_changes = [custom_parameters]
  }
}
