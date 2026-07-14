# WHAT: Remote backend configuration (Azure Storage) for Terraform state + locking.
# WHY : A remote backend gives shared, locked, encrypted state -- required for team/CI use and
#       for the pipeline's Init -> Plan -> Apply flow to be safe and idempotent.
# HOW : azurerm backend type. Values are intentionally left as partial configuration; the
#       Azure DevOps pipeline injects them at `terraform init` time via -backend-config
#       (see azure-pipelines/azure-pipelines.yml) so each environment (dev/test/prod) can use
#       its own state file/container without editing this file.

terraform {
  backend "azurerm" {
    # resource_group_name  = (supplied via -backend-config in pipeline)
    # storage_account_name = (supplied via -backend-config in pipeline)
    # container_name       = (supplied via -backend-config in pipeline)
    # key                  = (supplied via -backend-config in pipeline, e.g. "dev.terraform.tfstate")
    use_azuread_auth = true # authenticate to the backend storage account via Azure AD, not access keys
  }
}
