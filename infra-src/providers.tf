terraform {
  backend "azurerm" {}

  required_version = "~> 1.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 4.78.0"
    }
  }
}

provider "azurerm" {
  features {}
}

