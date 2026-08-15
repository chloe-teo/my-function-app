# Copilot instructions

## General guidance
- Keep changes aligned with the repository's Azure Function app and Terraform setup.
- Follow the existing module-driven pattern already used in this repo, where infrastructure is provisioned through reusable Terraform modules rather than ad hoc resource blocks.
- When creating new Azure resources, prefer referencing the shared module repository at https://github.com/chloe-teo/azure-modules and match the current patterns used by the existing Function App, Application Insights, and VNet modules.
- Prefer secure, reusable patterns over app-specific exceptions.
- Use environment-specific configuration and approved shared values instead of inventing new infrastructure details.
- Do not commit secrets, subscription IDs, or sensitive configuration values.

## Relevant topic-specific guidance
For private networking and private endpoint standards, follow the guidance in [private-networking-standards.md](private-networking-standards.md).

## Hard rule for private networking
- Never create private DNS zones, VNet links, or app-specific DNS resources in this repo.
- Always use the approved shared private DNS zone IDs from the central networking repo for private endpoints.
- Use only approved subnet IDs and VNet IDs from the central networking repo.
- If a new Azure service needs a private endpoint, read the generated approved values and pass them into the shared module rather than creating new DNS resources.

## Best practice for network ownership
- Keep app VNet and subnet variables separate from network-owned private DNS resource group values.
- Use `network_resource_group_name` for the application VNet resources and `private_dns_resource_group_name` for the shared network-owned DNS resource group.
- Do not reuse the app VNet resource group name for the shared private DNS zone resource group unless both are explicitly approved to be the same.

This file is intentionally limited to general repo guidance; the networking-specific rules live in the dedicated standards document.
