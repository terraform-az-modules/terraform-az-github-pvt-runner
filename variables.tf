##-----------------------------------------------------------------------------
## Labels
##-----------------------------------------------------------------------------
variable "name" {
  type        = string
  default     = null
  description = "Name  (e.g. `github-runner` or `app`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment", "location"]
  description = "Label order, e.g. `name`,`environment`,`location`."
}

variable "managedby" {
  type        = string
  default     = "terraform-az-modules"
  description = "ManagedBy, eg 'terraform-az-modules'."
}

variable "repository" {
  type        = string
  default     = "https://github.com/terraform-az-modules/terraform-az-github-pvt-runner"
  description = "Terraform current module repo"

  validation {
    condition     = can(regex("^https://", var.repository))
    error_message = "The module-repo value must be a valid Git repo link."
  }
}

variable "deployment_mode" {
  type        = string
  default     = "terraform"
  description = "Specifies how the infrastructure/resource is deployed."
}

variable "extra_tags" {
  type        = map(string)
  default     = null
  description = "Additional tags (e.g. `{ BusinessUnit = \"XYZ\" }`)."
}

##-----------------------------------------------------------------------------
## Module Control
##-----------------------------------------------------------------------------
variable "enabled" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources."
}

##-----------------------------------------------------------------------------
## Provider / Subscription
##-----------------------------------------------------------------------------
variable "subscription_id" {
  type        = string
  default     = null
  description = "Azure Subscription ID. Surfaced on the module for parity with the underlying Azure CLI workflow. Provider configuration is performed at the root module – this value is intended to be passed to the root `azurerm`/`azapi` providers (see `examples/complete/`)."
}

variable "location" {
  type        = string
  description = "Azure region where the GitHub Hosted Compute Networking resources are deployed (e.g. `eastus`, `westus2`)."
}

##-----------------------------------------------------------------------------
## Resource Group
##-----------------------------------------------------------------------------
variable "resource_group_name" {
  type        = string
  description = "Name of the Resource Group that will host the GitHub Hosted Compute Networking resources."
}

##-----------------------------------------------------------------------------
## Virtual Network – Runner Network
##-----------------------------------------------------------------------------
variable "vnet_name" {
  type        = string
  description = "Name of the Virtual Network that will host the delegated GitHub runner subnet."
}

variable "vnet_address_space" {
  type        = list(string)
  description = "Address space (CIDRs) of the Virtual Network that hosts the delegated GitHub runner subnet."
}

##-----------------------------------------------------------------------------
## Delegated Subnet – GitHub.Network/networkSettings
##-----------------------------------------------------------------------------
variable "runner_subnet_name" {
  type        = string
  description = "Name of the subnet delegated to `GitHub.Network/networkSettings`."
}

variable "runner_subnet_prefixes" {
  type        = list(string)
  description = "Address prefixes (CIDRs) for the delegated GitHub runner subnet."
}

##-----------------------------------------------------------------------------
## Network Security Group
##-----------------------------------------------------------------------------
variable "nsg_name" {
  type        = string
  description = "Name of the Network Security Group associated with the delegated GitHub runner subnet."
}

##-----------------------------------------------------------------------------
## GitHub Hosted Compute Network Settings
##-----------------------------------------------------------------------------
variable "network_settings_name" {
  type        = string
  description = "Name of the `GitHub.Network/networkSettings` resource registered with GitHub."
}

variable "network_settings_api_version" {
  type        = string
  default     = "2024-04-02"
  description = "API version for the `GitHub.Network/networkSettings` resource type."
}

variable "github_database_id" {
  type        = string
  description = "GitHub Organization or Enterprise database ID (also referred to as `businessId`) used to authorize the GitHub Hosted Compute network settings."
}

##-----------------------------------------------------------------------------
## Optional Runner VM
##-----------------------------------------------------------------------------
variable "enable_runner_vm" {
  type        = bool
  default     = false
  description = "Set to true to deploy an optional self-managed Linux Runner VM with its own Virtual Network and subnet (used for validation, jumpbox, or self-hosted runner scenarios)."
}

variable "runner_vm_name" {
  type        = string
  default     = null
  description = "Name of the optional Runner Virtual Machine. Required when `enable_runner_vm = true`."
}

variable "runner_vm_size" {
  type        = string
  default     = "Standard_B2s"
  description = "Azure VM size used for the optional Runner VM."
}

variable "runner_vm_admin_username" {
  type        = string
  default     = null
  description = "Administrator username for the optional Runner VM. Required when `enable_runner_vm = true`."
}

variable "runner_vm_admin_password" {
  type        = string
  default     = null
  sensitive   = true
  description = "Administrator password for the optional Runner VM. Required when `enable_runner_vm = true`. Pass via secure mechanism (env var, Key Vault) – never commit."
}

variable "runner_vm_vnet_address_space" {
  type        = list(string)
  default     = []
  description = "Address space (CIDRs) of the Virtual Network created for the optional Runner VM. Required when `enable_runner_vm = true`."
}

variable "runner_vm_subnet_name" {
  type        = string
  default     = null
  description = "Name of the subnet created for the optional Runner VM. Required when `enable_runner_vm = true`."
}

variable "runner_vm_subnet_prefixes" {
  type        = list(string)
  default     = []
  description = "Address prefixes (CIDRs) for the optional Runner VM subnet. Required when `enable_runner_vm = true`."
}

variable "runner_vm_image" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  description = "Marketplace image reference for the optional Runner VM."
}

variable "runner_vm_os_disk_storage_account_type" {
  type        = string
  default     = "StandardSSD_LRS"
  description = "Storage account type for the optional Runner VM OS disk."
}
