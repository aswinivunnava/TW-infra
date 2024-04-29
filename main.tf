terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}


provider "azurerm" {
  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
}

data "azurerm_resource_group" "RG1" {
  name     = "${var.prefix}-RG1"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-vnet1"
  resource_group_name = data.azurerm_resource_group.RG1.name
  location = data.azurerm_resource_group.RG1.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "${var.prefix}-subnet1"
  resource_group_name  = data.azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

