terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.33.0"
    }
      random = {
      source  = "hashicorp/random"
      version = "~> 3.4.3"
    }
    
  }
backend "azurerm" {}
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
    key_vault {
      purge_soft_delete_on_destroy = false
    }
  }
  use_oidc = true
  resource_provider_registrations = "none"
}

data "azurerm_client_config" "ServicePrincipal" {
}

resource "azurerm_resource_group" "rg" {
  name = "prenv-${var.environment}-RG"
  location = var.location
}