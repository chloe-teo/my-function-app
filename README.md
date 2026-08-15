# Function App Infrastructure Project

## Architecture

![End-to-end Azure Function App architecture](./images/function-app-architecture.svg)

## Terraform Modules And Azure Resources

![Terraform module and Azure resource relationship map](./images/terraform-module-resource-map.svg)


Terraform modules define the Azure resource group, Function App, service plan, Blob Storage, Key Vault, virtual network, private endpoints, private DNS zones, Application Insights, and role assignments. 

Azure DevOps builds and deploys the C# function package to the Function App. At runtime, the Function App uses Blob Storage and Key Vault through private endpoints with managed identity access, then exports traces and metrics with OpenTelemetry to Application Insights.