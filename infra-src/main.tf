locals {
  func_st                          = one(values(var.func_storage_account))
  storage_blob_private_dns_zone_id = "/subscriptions/${var.network_subscription_id}/resourceGroups/${var.private_dns_resource_group_name}/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
  key_vault_private_dns_zone_id    = "/subscriptions/${var.network_subscription_id}/resourceGroups/${var.private_dns_resource_group_name}/providers/Microsoft.Network/privateDnsZones/privatelink.vaultcore.azure.net"
  function_private_dns_zone_id     = "/subscriptions/${var.network_subscription_id}/resourceGroups/${var.private_dns_resource_group_name}/providers/Microsoft.Network/privateDnsZones/privatelink.azurewebsites.net"
  ip_restrictions = [
    for restriction in var.ip_restrictions : {
      name                      = restriction.name
      action                    = restriction.action
      ip_address                = try(restriction.ip_address, null)
      priority                  = restriction.priority
      virtual_network_subnet_id = try(module.azure-vnet.subnet_ids[restriction.virtual_network_subnet_name], null)
    }
  ]
}

module "azure-vnet" {
  source = "git::git@github.com:chloe-teo/azure-modules.git///azure-virtual-network?ref=main"

  resource_group_name                 = var.network_resource_group_name
  azure_virtual_network_name          = var.virtual_network_name
  azure_virtual_network_address_space = var.virtual_network_address_space
  subnets                             = var.subnets
  location                            = var.location
  tags                                = var.tags
}

module "app_insight" {
  source = "git::git@github.com:chloe-teo/azure-modules.git//azure-application-insight?ref=main"

  resource_group_name = var.resource_group_name
  location            = var.location
  apps_insights_name  = var.apps_insights_name
  application_type    = var.application_type
  tags                = local.tags
}

module "function_app" {
  source = "../../azure-modules/azure-function-app"

  application_insights_key               = module.app_insight.instrumentation_key
  application_insights_connection_string = module.app_insight.connection_string
  resource_group_name                    = var.resource_group_name
  location                               = var.location
  azure_function_app_name                = var.azure_function_app_name
  azure_service_plan_name                = var.azure_service_plan_name
  sku_name                               = var.sku_name
  os_type                                = var.os_type
  maximum_instance_count                 = var.maximum_instance_count
  instance_memory_in_mb                  = var.instance_memory_in_mb
  runtime_name                           = var.runtime_name
  runtime_version                        = var.runtime_version
  storage_account_name                   = local.func_st.name
  storage_account_kind                   = local.func_st.account_kind
  storage_account_tier                   = local.func_st.account_tier
  storage_account_replication_type       = local.func_st.account_replication_type
  storage_account_access_tier            = local.func_st.access_tier
  containers                             = local.func_st.containers
  public_network_access_enabled          = var.public_network_access_enabled && var.private_endpoint_subnet_name == null
  private_endpoint_subnet_id             = var.private_endpoint_subnet_name == null ? null : module.azure-vnet.subnet_ids[var.private_endpoint_subnet_name]
  private_dns_zone_ids                   = var.private_endpoint_subnet_name == null ? [] : [local.function_private_dns_zone_id]
  storage_private_endpoint_subnet_id     = module.azure-vnet.subnet_ids[var.private_endpoint_subnet_name]
  storage_blob_private_dns_zone_ids      = [local.storage_blob_private_dns_zone_id]
  scm_ip_restriction_default_action      = var.scm_ip_restriction_default_action
  ip_restrictions                        = local.ip_restrictions
  virtual_network_subnet_id              = module.azure-vnet.subnet_ids[var.func_outbound_subnet_name]
  tags                                   = local.tags
}

module "key_vault" {
  source = "../../azure-modules/azure-key-vault"

  resource_group_name           = var.resource_group_name
  location                      = var.location
  key_vault_name                = var.key_vault_name
  public_network_access_enabled = var.public_network_access_enabled
  role_assignments = {
    secrets_access = {
      principal_id         = module.function_app.identity_principal_id
      role_definition_name = "Key Vault Secrets User"
    }
  }
  private_endpoint_subnet_id = module.azure-vnet.subnet_ids[var.private_endpoint_subnet_name]
  private_dns_zone_ids       = [local.key_vault_private_dns_zone_id]
  tags                       = local.tags
}


resource "azurerm_role_assignment" "function_storage_access" {

  scope                = module.function_app.storage_account_id
  role_definition_name = "Storage Blob Data Owner"
  principal_id         = module.function_app.identity_principal_id
}

resource "azurerm_role_assignment" "app_insight_publisher" {

  scope                = module.app_insight.id
  role_definition_name = "Monitoring Metrics Publisher"
  principal_id         = module.function_app.identity_principal_id
}
