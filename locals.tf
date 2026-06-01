##-----------------------------------------------------------------------------
## Locals
##-----------------------------------------------------------------------------
locals {
  runner_vm_enabled  = var.enabled && var.enable_runner_vm
  github_delegation  = "GitHub.Network/networkSettings"
  github_action_join = "Microsoft.Network/virtualNetworks/subnets/join/action"
}
