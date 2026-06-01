##-----------------------------------------------------------------------------
## GitHub Hosted Compute Network Settings
##-----------------------------------------------------------------------------
output "network_settings_github_id" {
  value       = try(azapi_resource.github_network_settings[0].output.properties.githubId, null)
  description = "The GitHub identifier (`githubId`) returned by Azure after registering the `GitHub.Network/networkSettings` resource. Use this value in GitHub when creating a hosted runner group bound to this network configuration."
}

output "network_settings_resource_id" {
  value       = try(azapi_resource.github_network_settings[0].id, null)
  description = "The Azure Resource ID of the `GitHub.Network/networkSettings` resource."
}

##-----------------------------------------------------------------------------
## Resource Group
##-----------------------------------------------------------------------------
output "resource_group_name" {
  value       = try(azurerm_resource_group.runner[0].name, null)
  description = "The name of the Resource Group hosting the GitHub Hosted Compute Networking resources."
}

##-----------------------------------------------------------------------------
## Runner Network
##-----------------------------------------------------------------------------
output "vnet_name" {
  value       = try(azurerm_virtual_network.runner[0].name, null)
  description = "The name of the Virtual Network that hosts the delegated GitHub runner subnet."
}

output "runner_subnet_id" {
  value       = try(azurerm_subnet.runner[0].id, null)
  description = "The Azure Resource ID of the subnet delegated to `GitHub.Network/networkSettings`."
}

##-----------------------------------------------------------------------------
## Optional Runner VM
##-----------------------------------------------------------------------------
output "runner_vm_id" {
  value       = try(azurerm_linux_virtual_machine.runner_vm[0].id, null)
  description = "The Azure Resource ID of the optional Runner VM. Returns `null` when `enable_runner_vm` is `false`."
}

output "runner_vm_public_ip" {
  value       = try(azurerm_public_ip.runner_vm[0].ip_address, null)
  description = "The public IP address of the optional Runner VM. Returns `null` when `enable_runner_vm` is `false`."
}

output "runner_vm_subnet_id" {
  value       = try(azurerm_subnet.runner_vm[0].id, null)
  description = "The Azure Resource ID of the optional Runner VM subnet. Returns `null` when `enable_runner_vm` is `false`."
}

output "runner_vm_vnet_name" {
  value       = try(azurerm_virtual_network.runner_vm[0].name, null)
  description = "The name of the Virtual Network created for the optional Runner VM. Returns `null` when `enable_runner_vm` is `false`."
}
