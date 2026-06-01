##-----------------------------------------------------------------------------
## Tagging Module – Applies standard tags to all resources for traceability
##-----------------------------------------------------------------------------
module "labels" {
  source          = "terraform-az-modules/tags/azurerm"
  version         = "1.0.2"
  name            = var.name
  location        = var.location
  environment     = var.environment
  managedby       = var.managedby
  label_order     = var.label_order
  repository      = var.repository
  deployment_mode = var.deployment_mode
  extra_tags      = var.extra_tags
}

##-----------------------------------------------------------------------------
## Resource Group – Hosts all GitHub Hosted Compute Networking resources
##-----------------------------------------------------------------------------
resource "azurerm_resource_group" "runner" {
  count    = var.enabled ? 1 : 0
  name     = var.resource_group_name
  location = var.location
  tags     = module.labels.tags
}

##-----------------------------------------------------------------------------
## Network Security Group – Associated with the delegated GitHub runner subnet
##-----------------------------------------------------------------------------
resource "azurerm_network_security_group" "runner" {
  count               = var.enabled ? 1 : 0
  name                = var.nsg_name
  location            = azurerm_resource_group.runner[0].location
  resource_group_name = azurerm_resource_group.runner[0].name
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Virtual Network – Hosts the delegated GitHub runner subnet
##-----------------------------------------------------------------------------
resource "azurerm_virtual_network" "runner" {
  count               = var.enabled ? 1 : 0
  name                = var.vnet_name
  location            = azurerm_resource_group.runner[0].location
  resource_group_name = azurerm_resource_group.runner[0].name
  address_space       = var.vnet_address_space
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Delegated Subnet – Delegated to GitHub.Network/networkSettings
##-----------------------------------------------------------------------------
resource "azurerm_subnet" "runner" {
  count                = var.enabled ? 1 : 0
  name                 = var.runner_subnet_name
  resource_group_name  = azurerm_resource_group.runner[0].name
  virtual_network_name = azurerm_virtual_network.runner[0].name
  address_prefixes     = var.runner_subnet_prefixes

  delegation {
    name = "GitHubRunnerDelegation"
    service_delegation {
      name    = local.github_delegation
      actions = [local.github_action_join]
    }
  }
}

##-----------------------------------------------------------------------------
## NSG Subnet Association – Attaches NSG to the delegated GitHub runner subnet
##-----------------------------------------------------------------------------
resource "azurerm_subnet_network_security_group_association" "runner" {
  count                     = var.enabled ? 1 : 0
  subnet_id                 = azurerm_subnet.runner[0].id
  network_security_group_id = azurerm_network_security_group.runner[0].id
}

##-----------------------------------------------------------------------------
## GitHub Hosted Compute Network Settings – Registers the delegated subnet
## with GitHub so it can be selected when creating GitHub-hosted runner groups.
##-----------------------------------------------------------------------------
resource "azapi_resource" "github_network_settings" {
  count     = var.enabled ? 1 : 0
  type      = "GitHub.Network/networkSettings@${var.network_settings_api_version}"
  name      = var.network_settings_name
  location  = azurerm_resource_group.runner[0].location
  parent_id = azurerm_resource_group.runner[0].id
  tags      = module.labels.tags

  body = {
    properties = {
      businessId = var.github_database_id
      subnetId   = azurerm_subnet.runner[0].id
    }
  }

  response_export_values = ["properties.githubId"]

  depends_on = [
    azurerm_subnet_network_security_group_association.runner
  ]
}

##-----------------------------------------------------------------------------
## Optional Runner VM Virtual Network – Independent network for the VM
##-----------------------------------------------------------------------------
resource "azurerm_virtual_network" "runner_vm" {
  count               = local.runner_vm_enabled ? 1 : 0
  name                = format("%s-vnet", coalesce(var.runner_vm_name, "runner-vm"))
  location            = azurerm_resource_group.runner[0].location
  resource_group_name = azurerm_resource_group.runner[0].name
  address_space       = var.runner_vm_vnet_address_space
  tags                = module.labels.tags

  lifecycle {
    precondition {
      condition = !local.runner_vm_enabled || (
        var.runner_vm_name != null &&
        var.runner_vm_admin_username != null &&
        var.runner_vm_admin_password != null &&
        length(var.runner_vm_vnet_address_space) > 0 &&
        var.runner_vm_subnet_name != null &&
        length(var.runner_vm_subnet_prefixes) > 0
      )
      error_message = "When `enable_runner_vm = true`, the following variables are required: runner_vm_name, runner_vm_admin_username, runner_vm_admin_password, runner_vm_vnet_address_space, runner_vm_subnet_name, runner_vm_subnet_prefixes."
    }
  }
}

##-----------------------------------------------------------------------------
## Optional Runner VM Subnet
##-----------------------------------------------------------------------------
resource "azurerm_subnet" "runner_vm" {
  count                = local.runner_vm_enabled ? 1 : 0
  name                 = var.runner_vm_subnet_name
  resource_group_name  = azurerm_resource_group.runner[0].name
  virtual_network_name = azurerm_virtual_network.runner_vm[0].name
  address_prefixes     = var.runner_vm_subnet_prefixes
}

##-----------------------------------------------------------------------------
## Optional Runner VM Public IP – Standard SKU, static allocation
##-----------------------------------------------------------------------------
resource "azurerm_public_ip" "runner_vm" {
  count               = local.runner_vm_enabled ? 1 : 0
  name                = format("%s-pip", coalesce(var.runner_vm_name, "runner-vm"))
  location            = azurerm_resource_group.runner[0].location
  resource_group_name = azurerm_resource_group.runner[0].name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = module.labels.tags
}

##-----------------------------------------------------------------------------
## Optional Runner VM Network Interface
##-----------------------------------------------------------------------------
resource "azurerm_network_interface" "runner_vm" {
  count               = local.runner_vm_enabled ? 1 : 0
  name                = format("%s-nic", coalesce(var.runner_vm_name, "runner-vm"))
  location            = azurerm_resource_group.runner[0].location
  resource_group_name = azurerm_resource_group.runner[0].name
  tags                = module.labels.tags

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.runner_vm[0].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.runner_vm[0].id
  }
}

##-----------------------------------------------------------------------------
## Optional Linux Runner VM
##-----------------------------------------------------------------------------
resource "azurerm_linux_virtual_machine" "runner_vm" {
  count                           = local.runner_vm_enabled ? 1 : 0
  name                            = var.runner_vm_name
  resource_group_name             = azurerm_resource_group.runner[0].name
  location                        = azurerm_resource_group.runner[0].location
  size                            = var.runner_vm_size
  admin_username                  = var.runner_vm_admin_username
  admin_password                  = var.runner_vm_admin_password
  disable_password_authentication = false
  network_interface_ids           = [azurerm_network_interface.runner_vm[0].id]
  tags                            = module.labels.tags

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.runner_vm_os_disk_storage_account_type
  }

  source_image_reference {
    publisher = var.runner_vm_image.publisher
    offer     = var.runner_vm_image.offer
    sku       = var.runner_vm_image.sku
    version   = var.runner_vm_image.version
  }
}
