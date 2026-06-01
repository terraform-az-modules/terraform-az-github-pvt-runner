##-----------------------------------------------------------------------------
## Outputs
##-----------------------------------------------------------------------------
output "network_settings_github_id" {
  value       = module.github_pvt_runner.network_settings_github_id
  description = "The GitHub identifier (`githubId`) returned by Azure for the registered network settings."
}

output "network_settings_resource_id" {
  value       = module.github_pvt_runner.network_settings_resource_id
  description = "The Azure Resource ID of the `GitHub.Network/networkSettings` resource."
}

output "resource_group_name" {
  value       = module.github_pvt_runner.resource_group_name
  description = "The Resource Group hosting the GitHub Hosted Compute Networking resources."
}

output "vnet_name" {
  value       = module.github_pvt_runner.vnet_name
  description = "The Virtual Network that hosts the delegated GitHub runner subnet."
}

output "runner_subnet_id" {
  value       = module.github_pvt_runner.runner_subnet_id
  description = "The Azure Resource ID of the subnet delegated to `GitHub.Network/networkSettings`."
}

output "runner_vm_id" {
  value       = module.github_pvt_runner.runner_vm_id
  description = "The Azure Resource ID of the optional Runner VM."
}

output "runner_vm_public_ip" {
  value       = module.github_pvt_runner.runner_vm_public_ip
  description = "The public IP address of the optional Runner VM."
}

output "runner_vm_subnet_id" {
  value       = module.github_pvt_runner.runner_vm_subnet_id
  description = "The Azure Resource ID of the optional Runner VM subnet."
}

output "runner_vm_vnet_name" {
  value       = module.github_pvt_runner.runner_vm_vnet_name
  description = "The name of the Virtual Network created for the optional Runner VM."
}
