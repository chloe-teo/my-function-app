variable "azure_function_app_name" {
  description = "The name of the Azure Function App"
  type        = string
}

variable "key_vault_name" {
  description = "The globally unique Key Vault name used by the Function App."
  type        = string
}

variable "azure_service_plan_name" {
  description = "The name of the Azure Service Plan"
  type        = string
}

variable "apps_insights_name" {
  description = "The name of the Azure Application Insights"
  type        = string
}

variable "application_type" {
  description = "The application type of the Azure Application Insights"
  type        = string
  default     = "web"
}

variable "environment" {
  description = "The environment for the Azure Function App"
  type        = string
}

variable "sku_name" {
  description = "The SKU name of the Azure Service Plan"
  type        = string
}

variable "os_type" {
  description = "The OS type of the Azure Service Plan"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the resource group."
  type        = string
}

variable "func_storage_account" {
  description = "A map of storage account to create"
  type = map(object({
    name                     = string
    account_kind             = string
    account_replication_type = string
    account_tier             = string
    access_tier              = string
    containers = map(object({
      name        = string
      access_type = string
    }))
  }))
}

variable "maximum_instance_count" {
  description = "The maximum number of instances for the Azure Function App"
  type        = number
  default     = 3
}

variable "instance_memory_in_mb" {
  description = "The amount of memory in MB for each instance of the Azure Function App"
  type        = number
  default     = 512
}

variable "runtime_version" {
  description = "The runtime version of the Azure Function App."
  type        = string
}

variable "runtime_name" {
  description = "The runtime name of the Azure Function App"
  type        = string
  default     = "dotnet-isolated"
}

variable "tags" {
  description = "A map of tags to assign to the resources"
  type        = map(string)
  default     = {}
}

variable "network_resource_group_name" {
  description = "The name of the resource group containing the virtual network for the application"
  type        = string
}

variable "private_dns_resource_group_name" {
  description = "The resource group owned by the network team that contains the shared private DNS zones"
  type        = string
}

variable "network_subscription_id" {
  description = "The Azure subscription ID owned by the network team that contains the shared private DNS zones"
  type        = string
}

variable "public_network_access_enabled" {
  description = "Should public network access be enabled for the Azure Function App"
  type        = bool
  default     = false
}

variable "ip_restrictions" {
  description = "A list of IP restriction rules for the Azure Function App"
  type = list(object({
    name                        = string
    action                      = string
    ip_address                  = optional(string)
    virtual_network_subnet_name = optional(string)
    priority                    = number
  }))
  default = []
}

variable "virtual_network_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "virtual_network_address_space" {
  description = "The address space of the Azure virtual network"
  type        = list(string)
}

variable "subnets" {
  description = "The list of subnets"
  type = map(object({
    name             = string
    address_prefixes = list(string)
    delegation = optional(object({
      name    = string
      actions = list(string)
    }))
    service_endpoints = optional(list(string), [])
  }))
}

variable "func_subnet_name" {
  type        = string
  description = "Name of the Function App integration subnet"
}

variable "private_endpoint_subnet_name" {
  type        = string
  description = "Name of the subnet for private endpoints"
}

variable "scm_ip_restriction_default_action" {
  description = "The default action for SCM IP restrictions"
  type        = string
}
