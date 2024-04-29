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


resource "azurerm_linux_virtual_machine" "VM1" {
  name                = "${var.prefix}-machine"
  resource_group_name = data.zurerm_resource_group.RG1.name
  location            = data.azurerm_resource_group.RG1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"


  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching             = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "RedHat"
    offer     = "rhel-byos"
    sku       = "7-raw"
    version   = "latest"
  }
}
