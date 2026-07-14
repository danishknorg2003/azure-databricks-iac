# WHAT: Input variables for the Resource Group module.
# WHY : Keeps the module reusable across environments (dev/test/prod).
# HOW : Values are passed from the root module's main.tf.

variable "name" {
  description = "Name of the Azure Resource Group."
  type        = string
}

variable "location" {
  description = "Azure region where the Resource Group will be created."
  type        = string
}

variable "tags" {
  description = "Common tags applied to the Resource Group."
  type        = map(string)
  default     = {}
}
