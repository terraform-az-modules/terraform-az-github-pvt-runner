## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| deployment\_mode | Specifies how the infrastructure/resource is deployed. | `string` | `"terraform"` | no |
| enable\_runner\_vm | Set to true to deploy an optional self-managed Linux Runner VM with its own Virtual Network and subnet (used for validation, jumpbox, or self-hosted runner scenarios). | `bool` | `false` | no |
| enabled | Set to false to prevent the module from creating any resources. | `bool` | `true` | no |
| environment | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| extra\_tags | Additional tags (e.g. `{ BusinessUnit = "XYZ" }`). | `map(string)` | `null` | no |
| github\_database\_id | GitHub Organization or Enterprise database ID (also referred to as `businessId`) used to authorize the GitHub Hosted Compute network settings. | `string` | n/a | yes |
| label\_order | Label order, e.g. `name`,`environment`,`location`. | `list(any)` | <pre>[<br>  "name",<br>  "environment",<br>  "location"<br>]</pre> | no |
| location | Azure region where the GitHub Hosted Compute Networking resources are deployed (e.g. `eastus`, `westus2`). | `string` | n/a | yes |
| managedby | ManagedBy, eg 'terraform-az-modules'. | `string` | `"terraform-az-modules"` | no |
| name | Name  (e.g. `github-runner` or `app`). | `string` | `null` | no |
| network\_settings\_api\_version | API version for the `GitHub.Network/networkSettings` resource type. | `string` | `"2024-04-02"` | no |
| network\_settings\_name | Name of the `GitHub.Network/networkSettings` resource registered with GitHub. | `string` | n/a | yes |
| nsg\_name | Name of the Network Security Group associated with the delegated GitHub runner subnet. | `string` | n/a | yes |
| repository | Terraform current module repo | `string` | `"https://github.com/terraform-az-modules/terraform-az-github-pvt-runner"` | no |
| resource\_group\_name | Name of the Resource Group that will host the GitHub Hosted Compute Networking resources. | `string` | n/a | yes |
| runner\_subnet\_name | Name of the subnet delegated to `GitHub.Network/networkSettings`. | `string` | n/a | yes |
| runner\_subnet\_prefixes | Address prefixes (CIDRs) for the delegated GitHub runner subnet. | `list(string)` | n/a | yes |
| runner\_vm\_admin\_password | Administrator password for the optional Runner VM. Required when `enable_runner_vm = true`. Pass via secure mechanism (env var, Key Vault) – never commit. | `string` | `null` | no |
| runner\_vm\_admin\_username | Administrator username for the optional Runner VM. Required when `enable_runner_vm = true`. | `string` | `null` | no |
| runner\_vm\_image | Marketplace image reference for the optional Runner VM. | <pre>object({<br>    publisher = string<br>    offer     = string<br>    sku       = string<br>    version   = string<br>  })</pre> | <pre>{<br>  "offer": "0001-com-ubuntu-server-jammy",<br>  "publisher": "Canonical",<br>  "sku": "22_04-lts-gen2",<br>  "version": "latest"<br>}</pre> | no |
| runner\_vm\_name | Name of the optional Runner Virtual Machine. Required when `enable_runner_vm = true`. | `string` | `null` | no |
| runner\_vm\_os\_disk\_storage\_account\_type | Storage account type for the optional Runner VM OS disk. | `string` | `"StandardSSD_LRS"` | no |
| runner\_vm\_size | Azure VM size used for the optional Runner VM. | `string` | `"Standard_B2s"` | no |
| runner\_vm\_subnet\_name | Name of the subnet created for the optional Runner VM. Required when `enable_runner_vm = true`. | `string` | `null` | no |
| runner\_vm\_subnet\_prefixes | Address prefixes (CIDRs) for the optional Runner VM subnet. Required when `enable_runner_vm = true`. | `list(string)` | `[]` | no |
| runner\_vm\_vnet\_address\_space | Address space (CIDRs) of the Virtual Network created for the optional Runner VM. Required when `enable_runner_vm = true`. | `list(string)` | `[]` | no |
| subscription\_id | Azure Subscription ID. Surfaced on the module for parity with the underlying Azure CLI workflow. Provider configuration is performed at the root module – this value is intended to be passed to the root `azurerm`/`azapi` providers (see `examples/complete/`). | `string` | `null` | no |
| vnet\_address\_space | Address space (CIDRs) of the Virtual Network that hosts the delegated GitHub runner subnet. | `list(string)` | n/a | yes |
| vnet\_name | Name of the Virtual Network that will host the delegated GitHub runner subnet. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| network\_settings\_github\_id | The GitHub identifier (`githubId`) returned by Azure after registering the `GitHub.Network/networkSettings` resource. Use this value in GitHub when creating a hosted runner group bound to this network configuration. |
| network\_settings\_resource\_id | The Azure Resource ID of the `GitHub.Network/networkSettings` resource. |
| resource\_group\_name | The name of the Resource Group hosting the GitHub Hosted Compute Networking resources. |
| runner\_subnet\_id | The Azure Resource ID of the subnet delegated to `GitHub.Network/networkSettings`. |
| runner\_vm\_id | The Azure Resource ID of the optional Runner VM. Returns `null` when `enable_runner_vm` is `false`. |
| runner\_vm\_public\_ip | The public IP address of the optional Runner VM. Returns `null` when `enable_runner_vm` is `false`. |
| runner\_vm\_subnet\_id | The Azure Resource ID of the optional Runner VM subnet. Returns `null` when `enable_runner_vm` is `false`. |
| runner\_vm\_vnet\_name | The name of the Virtual Network created for the optional Runner VM. Returns `null` when `enable_runner_vm` is `false`. |
| vnet\_name | The name of the Virtual Network that hosts the delegated GitHub runner subnet. |

