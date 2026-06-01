# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-06-01

### Added
- Initial release of the GitHub Hosted Compute Networking module.
- Provisions Resource Group, Network Security Group, Virtual Network, delegated subnet (`GitHub.Network/networkSettings`), NSG association, and the `GitHub.Network/networkSettings` resource (apiVersion `2024-04-02`).
- Optional self-managed Linux Runner VM with dedicated VNet, subnet, public IP, NIC, and Ubuntu image.
- Exposes `network_settings_github_id`, `network_settings_resource_id`, `resource_group_name`, `vnet_name`, `runner_subnet_id`, `runner_vm_id`, `runner_vm_public_ip`, `runner_vm_subnet_id`, and `runner_vm_vnet_name` outputs.
- Complete example under `examples/complete/`.
- Production README with Architecture, Prerequisites, Azure CLI alternative, Terraform deployment, Organization-level and Enterprise-level setup, Runner Group configuration, GitHub Hosted Runner creation, Outputs, Validation, and Troubleshooting sections.
