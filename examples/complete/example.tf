provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}

provider "azapi" {
  subscription_id = var.subscription_id
}

##-----------------------------------------------------------------------------
## GitHub Hosted Compute Networking – Complete Example
##
## This example provisions:
##   * Resource Group
##   * Network Security Group
##   * Virtual Network
##   * Delegated Subnet (GitHub.Network/networkSettings)
##   * GitHub Hosted Compute Network Settings (azapi)
##   * Optional Runner VM (separate VNet, subnet, public IP, NIC, Linux VM)
##-----------------------------------------------------------------------------
module "github_pvt_runner" {
  source = "../../"

  name        = "core"
  environment = "dev"
  label_order = ["name", "environment", "location"]

  subscription_id = var.subscription_id
  location        = var.location

  resource_group_name = var.resource_group_name

  vnet_name          = var.vnet_name
  vnet_address_space = var.vnet_address_space

  runner_subnet_name     = var.runner_subnet_name
  runner_subnet_prefixes = var.runner_subnet_prefixes

  nsg_name = var.nsg_name

  network_settings_name        = var.network_settings_name
  network_settings_api_version = var.network_settings_api_version
  github_database_id           = var.github_database_id

  enable_runner_vm             = var.enable_runner_vm
  runner_vm_name               = var.runner_vm_name
  runner_vm_admin_username     = var.runner_vm_admin_username
  runner_vm_admin_password     = var.runner_vm_admin_password
  runner_vm_vnet_address_space = var.runner_vm_vnet_address_space
  runner_vm_subnet_name        = var.runner_vm_subnet_name
  runner_vm_subnet_prefixes    = var.runner_vm_subnet_prefixes
}
