# Azure private networking standards

## Source of truth
The central network repository from this URL https://github.com/chloe-teo/central-private-dns is the source of truth for shared private DNS zone IDs, approved subnet IDs, and approved VNet IDs.

Use the values in the central network repo for the target environment. Do not create app-specific private DNS zones unless the network team explicitly approves an exception.

## Required workflow
1. Read the target environment values file from the central network repo.
2. Confirm the environment name and approved private DNS zone IDs.
3. Use the approved shared DNS zone IDs for private endpoints.
4. Use only approved private endpoint subnet IDs.
5. Do not invent DNS IDs or private endpoint subnet values.
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
When creating a new private endpoint for any Azure service, follow this sequence:
1. Read the approved values from the central-private-dns generated environment file.
2. Copy the approved DNS zone ID for the target service.
3. Use the approved subnet ID for the private endpoint.
4. Pass both values into the shared module.
5. Do not create a new DNS zone or VNet link in this repo.
