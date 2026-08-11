# Azure Function App

## Architecture

![End-to-end Azure Function App architecture](../images/function-app-architecture.svg)

## Terraform Modules And Azure Resources

![Terraform module and Azure resource relationship map](../images/terraform-module-resource-map.svg)

Terraform modules define the Azure resource group, Function App, service plan, Blob Storage, virtual network, private endpoint, private DNS zone, Application Insights, and role assignments. Azure DevOps builds and deploys the C# function package to the Function App. At runtime, the Function App uses Blob Storage through the private endpoint and exports traces and metrics with OpenTelemetry to Application Insights.