# Azure private networking standards

## Source of truth
The central network repository at https://github.com/chloe-teo/central-private-dns is the source of truth for shared private DNS zone IDs.

[approved-vnet-subnet.md](approved-vnet-subnet.md) is the source of truth for the approved network resource group, VNet, and private-endpoint subnet for each application environment.

The URL is an executable research requirement, not background documentation. Before declaring network values unavailable, the agent must attempt a direct query of this repository and report the result.

## Required workflow
1. Before any design, plan, variable declaration, or Terraform edit involving a private endpoint, must query https://github.com/chloe-teo/central-private-dns directly, discover the available environments under `generated/`, and read `generated/<environment>/approved-network-values.json`. 
2. Record the direct query result before deciding whether to edit:
	- If one or more `generated/<environment>/` directories are discovered and the deployment environment is unspecified, list every discovered environment name and ask the user to choose one. Do not infer a default. Use `dev` only after the user explicitly selects `dev`.
	- If no generated environments can be discovered, distinguish an empty `generated/` directory from an inaccessible repository, directory listing, or generated artifact. Report the exact URL and result, then stop without editing. Do not ask the user to choose from an undiscovered or empty environment list.
3. After the user selects an environment, read `generated/<environment>/approved-network-values.json` and confirm its `environment` value matches the selection.
4. Find the approved private DNS zone ID for the target Azure service in `approved_private_dns_zones`.
5. If the required service key is missing, stop and tell the developer that networking approval or regenerated central values are required; do not infer, construct, or hardcode a replacement ID.
6. Read [approved-vnet-subnet.md](approved-vnet-subnet.md) and confirm it contains the selected environment's network resource group, VNet, and private-endpoint subnet before creating a private endpoint.
7. Use only the approved DNS zone ID and the approved private-endpoint subnet as inputs to the shared module.
8. Never create private DNS zone resources in this application repo.
9. Never create `azurerm_private_dns_zone` or `azurerm_private_dns_zone_virtual_network_link` resources in app code unless the network team explicitly approves a documented exception.
10. If the repository, generated values file, approved VNet/subnet document, or required environment cannot be accessed, report the unavailable source and stop without editing. Do not infer replacement network values.

## Hard rule for future work
When creating a new private endpoint for any Azure service, or adding variables for a new private DNS zone type, must follow this sequence:
1. Read the approved values from the central-private-dns generated environment file.
2. Confirm that the target service has an entry in `approved_private_dns_zones`.
3. If it does not, report the missing entry and stop until the central network values are updated.
4. Read [approved-vnet-subnet.md](approved-vnet-subnet.md) and confirm its VNet and subnet values for the selected environment.
5. Pass the approved DNS zone ID and approved private-endpoint subnet ID into the shared module.
6. Do not create a new DNS zone, VNet, subnet, or VNet link in this repo.

## Standard practice
- Shared private DNS zones are the default pattern.
- Network team owns the DNS zone lifecycle.
- Application teams consume the approved values from the central network repo.
- Application teams use [approved-vnet-subnet.md](approved-vnet-subnet.md) for private-endpoint VNet and subnet placement.
- The application repo does not create or manage private DNS zone resources.
- If a resource needs a private endpoint, read the generated approved values from the central network repo and pass the approved IDs into the shared module.
- Never hardcode Azure subscription IDs in Terraform, generated JSON, or checked-in config files. Use the local environment variable `ARM_SUBSCRIPTION_ID` at runtime and substitute it in generated values only when needed.
- Treat any subscription GUID as sensitive data. Do not commit it to GitHub, even in example JSON or generated outputs.


## Reference files
- central-network-repo/generated/<environment>/approved-network-values.json
- central-network-repo/README.md
- [approved-vnet-subnet.md](approved-vnet-subnet.md)

## Validation checklist
Before finalizing infrastructure changes, must confirm:
- the target environment matches the deployment environment
- the DNS zone IDs are from the approved central values file
- the private endpoint uses the approved VNet and subnet from [approved-vnet-subnet.md](approved-vnet-subnet.md)
- the Azure service being connected uses the correct private DNS zone
- any subscription ID used in generated values is resolved from the local `ARM_SUBSCRIPTION_ID` environment variable, not stored in the repo

## Example
For storage private endpoints, use the approved shared zone IDs for:
- blob
- queue
- table
- file

Use the central network values file rather than creating per-app private DNS zones.