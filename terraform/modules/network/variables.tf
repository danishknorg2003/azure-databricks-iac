# WHAT: Input variables for the Network module.
# WHY : Databricks with VNet injection + Secure Cluster Connectivity requires a dedicated
#       VNet with two delegated subnets (public/host and private/container).
# HOW : Values supplied by root module; CIDR ranges are environment-specific.

variable "resource_group_name" {
  description = "Resource Group where the network resources will be created."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "vnet_name" {
  description = "Name of the Virtual Network."
  type        = string
}

variable "vnet_address_space" {
  description = "Address space for the VNet."
  type        = list(string)
}

variable "public_subnet_name" {
  description = "Name of the public (host) subnet used by Databricks."
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
}

variable "private_subnet_name" {
  description = "Name of the private (container) subnet used by Databricks."
  type        = string
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet."
  type        = string
}

variable "tags" {
  description = "Common tags."
  type        = map(string)
  default     = {}
}
