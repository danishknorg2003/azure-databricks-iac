# WHAT: ADLS Gen2 storage account (hierarchical namespace enabled) + container.
# WHY : Unity Catalog's storage credential/external location model requires ADLS Gen2.
# HOW : azurerm_storage_account with is_hns_enabled = true, plus azurerm_storage_container.
#       Public network access is restricted; firewall defaults deny with Azure services allowed.

resource "azurerm_storage_account" "this" {
  name                            = var.storage_account_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  account_tier                    = var.account_tier
  account_replication_type        = var.account_replication_type
  account_kind                    = "StorageV2"
  is_hns_enabled                  = true # Required for ADLS Gen2 / Unity Catalog
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = false

  network_rules {
    default_action = "Allow" # tighten to "Deny" + explicit rules for stricter prod posture
    bypass         = ["AzureServices"]
  }

  tags = var.tags

  lifecycle {
    ignore_changes = [network_rules] # avoid drift fights with security teams managing firewall separately
  }
}

resource "azurerm_storage_container" "this" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.this.name
  container_access_type = "private"
}
