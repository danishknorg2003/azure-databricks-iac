# WHAT: Terraform and provider version constraints.
# WHY : Pins versions to avoid unexpected breaking changes from provider upgrades in CI/CD.
# HOW : required_version + required_providers with conservative ~> pinning.

terraform {
  required_version = ">= 1.7.0, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.50"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }
}
