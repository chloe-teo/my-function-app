azure_function_app_name           = "mylab-func-app"
azure_service_plan_name           = "mylab-func-app-plan"
apps_insights_name                = "myab-func-app-insights"
application_type                  = "web"
sku_name                          = "FC1"
os_type                           = "Linux"
maximum_instance_count            = 5
instance_memory_in_mb             = 512
runtime_name                      = "dotnet-isolated"
runtime_version                   = "10.0"
location                          = "Sweden Central"
resource_group_name               = "rg-dev"
network_resource_group_name       = "rg-dev-network"
private_dns_resource_group_name   = "rg-dev-network"
scm_ip_restriction_default_action = "Allow"
virtual_network_name              = "vnet-dev-func-app"
virtual_network_address_space     = ["10.0.0.0/16"]
environment                       = "dev"
tags = {
  "project" = "lab-function-app"
}

func_storage_account = {
  labfuncappst = {
    name                     = "labfuncappst"
    account_kind             = "StorageV2"
    account_replication_type = "LRS"
    account_tier             = "Standard"
    access_tier              = "Hot"
    containers = {
      "func-storage" = {
        name        = "func-storage"
        access_type = "private"
      }
    }
  }
}

func_subnet_name             = "subnet-dev-function"
private_endpoint_subnet_name = "subnet-dev-other"

ip_restrictions = [
  {
    name                        = "allow-function-subnet"
    action                      = "Allow"
    priority                    = 110
    virtual_network_subnet_name = "subnet-dev-function"
  }
]

subnets = {
  function = {
    name             = "subnet-dev-function"
    address_prefixes = ["10.0.3.0/28"]
    delegation = {
      name    = "Microsoft.App/environments"
      actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
    }
    service_endpoints = ["Microsoft.Web"]
  }

  other = {
    name             = "subnet-dev-other"
    address_prefixes = ["10.0.4.0/28"]
  }
}
