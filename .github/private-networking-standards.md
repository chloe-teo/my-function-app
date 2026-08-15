# Azure private networking standards

## Source of truth
The central network repository from this URL https://github.com/chloe-teo/central-private-dns is the source of truth for shared private DNS zone IDs, approved subnet IDs, and approved VNet IDs.

Use the values in the central network repo for the target environment. Do not create app-specific private DNS zones unless the network team explicitly approves an exception.

## Required workflow
1. Must read `central-private-dns/generated/<environment>/approved-network-values.json` before designing or editing a private endpoint, and before adding variables for a new private DNS zone type.
2. Confirm that the file's environment matches the deployment environment.
3. Find the approved private DNS zone ID for the target Azure service in `approved_private_dns_zones`.
4. If the required service key is missing, stop and tell the developer that networking approval or regenerated central values are required; do not infer, construct, or hardcode a replacement ID.
5. Use only the approved DNS zone ID and approved private endpoint subnet ID as inputs to the shared module.
6. Never create private DNS zone resources in this application repo.
7. Never create `azurerm_private_dns_zone` or `azurerm_private_dns_zone_virtual_network_link` resources in app code unless the network team explicitly approves a documented exception.

## Standard practice
- Shared private DNS zones are the default pattern.
- Network team owns the DNS zone lifecycle.
- Application teams consume the approved values from the central network repo.
- The application repo does not create or manage private DNS zone resources.
- If a resource needs a private endpoint, read the generated approved values from the central network repo and pass the approved IDs into the shared module.
- New Azure resources should follow the repository's current Terraform setup and use reusable modules from https://github.com/chloe-teo/azure-modules wherever possible, rather than creating standalone resource definitions that do not match the existing module pattern.
- Never hardcode Azure subscription IDs in Terraform, generated JSON, or checked-in config files. Use the local environment variable `ARM_SUBSCRIPTION_ID` at runtime and substitute it in generated values only when needed.
- Treat any subscription GUID as sensitive data. Do not commit it to GitHub, even in example JSON or generated outputs.

## Reference files
- central-network-repo/generated/<environment>/approved-network-values.json
- central-network-repo/README.md

## Validation checklist
Before finalizing infrastructure changes, confirm:
- the target environment matches the deployment environment
- the DNS zone IDs are from the approved central values file
- the private endpoint subnet is approved by networking
- the Azure service being connected uses the correct private DNS zone
- any subscription ID used in generated values is resolved from the local `ARM_SUBSCRIPTION_ID` environment variable, not stored in the repo

## Example
For storage private endpoints, use the approved shared zone IDs for:
- blob
- queue
- table
- file

Use the central network values file rather than creating per-app private DNS zones.

## Hard rule for future work
When creating a new private endpoint for any Azure service, or adding variables for a new private DNS zone type, must follow this sequence:
1. Read the approved values from the central-private-dns generated environment file.
2. Confirm that the target service has an entry in `approved_private_dns_zones`.
3. If it does not, report the missing entry and stop until the central network values are updated.
4. Pass the approved DNS zone ID and subnet ID into the shared module.
5. Do not create a new DNS zone or VNet link in this repo.
