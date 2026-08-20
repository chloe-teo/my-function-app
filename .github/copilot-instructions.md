# Copilot instructions

## Hard rule guidance
- Keep changes aligned with the repository's Azure Function app and Terraform setup.
- Follow the existing module-driven pattern already used in this repo, where infrastructure is provisioned through reusable Terraform modules rather than ad hoc resource blocks.
- Follow the existing module-driven pattern already used if there is in this repo, where infrastructure is provisioned through reusable Terraform modules rather than ad hoc resource blocks.
- When creating new Azure resources, must always referencing the shared module repository at https://github.com/chloe-teo/azure-modules and match the current patterns used by the existing
- Prefer secure, reusable patterns over app-specific exceptions.
- Must use private networking as first-class design for all Azure services that support private endpoints, and must use approved shared private DNS zones rather than creating app-specific private DNS zones.
- **Mandatory pre-edit gate:** Before editing any Azure resource that supports private endpoints, locate and read [Hard rule for private networking](#hard-rule-for-private-networking). Confirm that every required service has shared private DNS zone ID. If the file or any required entry is unavailable, stop without editing and report that central networking approval or regenerated values are required.
- Must never commit secrets, subscription IDs, or sensitive configuration values.
- The agent should avoid `count` for repeatable or optional resource instances; use `for_each` whenever a resource can have multiple instances or can be conditionally represented as a collection.

## Must follow Terraform file structure
- Keep Terraform root modules organized by responsibility:
	- `providers.tf` for Terraform and provider requirements and provider configuration.
	- `variables.tf` for input variables and their validation rules.
	- `locals.tf` for derived names, maps, and reusable expressions.
	- `main.tf` for module and resource declarations.
	- `output.tf` for values exposed by the root module.
- Do not place all Terraform configuration in `main.tf` when the configuration has more than one responsibility. Preserve the existing file structure when modifying an established module.


## Hard rule for private networking
- Never create private DNS zones, VNet links, or app-specific DNS resources in this repo.
- Before creating or modifying a private endpoint, or before creating variables for a new private DNS zone type, must read and confirm the target service has an approved DNS zone ID and follow the guidance in [private-networking-standards.md](private-networking-standards.md)
- If the required DNS zone entry is missing, tell the developer that central networking approval or regenerated values are required and stop; never infer, construct, or hardcode a replacement ID.
- Pass the approved DNS zone ID into the shared module rather than creating new DNS resources.

## Private networking validation gate
- Before declaring the work complete, verify that each supported Azure service has private endpoints configured for all required subresources, public network access is disabled, and approved private DNS zone IDs are used.
- Run `terraform fmt`, `terraform validate`, and, when credentials and backend inputs are available, `terraform plan`. Inspect the plan for private endpoint creation and disabled public access before recommending apply.

## Best practice for network ownership
- Keep app VNet and subnet variables separate from network-owned private DNS resource group values.
- Use `network_resource_group_name` for the application VNet resources and `private_dns_resource_group_name` for the shared network-owned DNS resource group.
- Do not reuse the app VNet resource group name for the shared private DNS zone resource group unless both are explicitly approved to be the same.

This file is intentionally limited to general repo guidance; the networking-specific rules live in the dedicated standards document.