terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id

  # Lo estabas usando antes; lo dejamos igual para no romper nada.
  skip_provider_registration = true
}
