##-----------------------------------------------------------------------------
## Variables
##-----------------------------------------------------------------------------
variable "subscription_id" {
  type        = string
  default     = null
  description = "Azure Subscription ID. When `null`, the provider uses the current subscription from the environment."
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region for the deployment."
}

variable "resource_group_name" {
  type        = string
  default     = "rg-github-runner-dev"
  description = "Resource Group that hosts the GitHub Hosted Compute Networking resources."
}

variable "vnet_name" {
  type        = string
  default     = "vnet-github-runner-dev"
  description = "Virtual Network that hosts the delegated GitHub runner subnet."
}

variable "vnet_address_space" {
  type        = list(string)
  default     = ["10.10.0.0/16"]
  description = "Address space of the runner Virtual Network."
}

variable "runner_subnet_name" {
  type        = string
  default     = "snet-github-runner"
  description = "Name of the subnet delegated to `GitHub.Network/networkSettings`."
}

variable "runner_subnet_prefixes" {
  type        = list(string)
  default     = ["10.10.1.0/24"]
  description = "Address prefixes for the delegated GitHub runner subnet."
}

variable "nsg_name" {
  type        = string
  default     = "nsg-github-runner-dev"
  description = "Name of the Network Security Group attached to the delegated runner subnet."
}

variable "network_settings_name" {
  type        = string
  default     = "github-runner-network-settings"
  description = "Name of the `GitHub.Network/networkSettings` resource."
}

variable "network_settings_api_version" {
  type        = string
  default     = "2024-04-02"
  description = "API version for the `GitHub.Network/networkSettings` resource type."
}

variable "github_database_id" {
  type        = string
  description = "GitHub Organization or Enterprise database ID (`businessId`). Replace before running."
  default     = "replace-me"
}

variable "enable_runner_vm" {
  type        = bool
  default     = false
  description = "Set to true to deploy the optional self-managed Linux Runner VM alongside the GitHub Hosted Compute Networking resources."
}

variable "runner_vm_name" {
  type        = string
  default     = "vm-github-runner-dev"
  description = "Name of the optional Runner VM."
}

variable "runner_vm_admin_username" {
  type        = string
  default     = "azureuser"
  description = "Administrator username for the optional Runner VM."
}

variable "runner_vm_admin_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Administrator password for the optional Runner VM. Provide via TF_VAR_runner_vm_admin_password or a secure variable file."
}

variable "runner_vm_vnet_address_space" {
  type        = list(string)
  default     = ["10.20.0.0/16"]
  description = "Address space for the optional Runner VM Virtual Network."
}

variable "runner_vm_subnet_name" {
  type        = string
  default     = "snet-runner-vm"
  description = "Name of the optional Runner VM subnet."
}

variable "runner_vm_subnet_prefixes" {
  type        = list(string)
  default     = ["10.20.1.0/24"]
  description = "Address prefixes for the optional Runner VM subnet."
}
