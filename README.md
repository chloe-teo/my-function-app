# Function App Infrastructure Project

## Architecture

![End-to-end Azure Function App architecture](./images/function-app-architecture.svg)

## Terraform Modules And Azure Resources

![Terraform module and Azure resource relationship map](./images/terraform-module-resource-map.svg)


Terraform modules define the Azure resource group, Function App, service plan, Blob Storage, Key Vault, virtual network, private endpoints, private DNS zones, and role assignments. Azure DevOps builds and deploys the C# function package to the Function App.

The Function App is now reachable through a private endpoint in the dedicated private-endpoint subnet. It uses managed identity access and VNet integration to Blob Storage and Key Vault through their private endpoints. IP restrictions remain configured for application and SCM access.