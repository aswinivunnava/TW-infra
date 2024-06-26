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

data "azurerm_key_vault" "TW-KV" {
  name                = "TW-key-vault"
  resource_group_name = data.azurerm_resource_group.RG1.name
}

data "azurerm_key_vault_secret" "ID-RSA-KEY" {
  name         = "TW-Key"
  key_vault_id = data.azurerm_key_vault.TW-KV.id
}

resource "azurerm_linux_virtual_machine" "VM-webserver" {
  name                = "${var.prefix}-webserver"
  resource_group_name = data.azurerm_resource_group.RG1.name
  location            = data.azurerm_resource_group.RG1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"


  admin_ssh_key {
    username   = "adminuser"
    public_key = data.azurerm_key_vault_secret.ID-RSA-KEY.value
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
  provisioner "file" {
    source = "./provisioner-webServer.sh"
    destination = "/home/apache/provisioner-webServer.sh"
  }
  provisioner "file" {
    source = "./MediaWiki-download.sh"
    destination = "/home/apache/MediaWiki-download.sh"
  }
  provisioner "file" {
    source = "./firewall.sh"
    destination = "/home/apache/firewall.sh"
  }
  provisioner "file" {
    source = "./selinux-disabling.sh"
    destination = "/home/apache/selinux-disabling.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/apache/provisioner-webServer.sh",
      "/home/apache/provisioner-webServer.sh"
      "chmod +x /home/apache/MediaWiki-download.sh",
      "~/MediaWiki-download.sh"
      "chmod +x /home/apache/firewall.sh",
      "/home/apache/firewall.sh"
    ]
  }
}
resource "azurerm_linux_virtual_machine" "VM-mariadb" {
  name                = "${var.prefix}-mariadb"
  resource_group_name = data.azurerm_resource_group.RG1.name
  location            = data.azurerm_resource_group.RG1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"


  admin_ssh_key {
    username   = "adminuser"
    public_key = data.azurerm_key_vault_secret.ID-RSA-KEY.value
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
  provisioner "file" {
    source = "./provision-db-packages.sh"
    destination = "~/provision-db-packages.sh"
  }
  provisioner "remote-exec" {
    inline = [
      "chmod +x ~/provision-db-packages.sh",
      "~/provision-db-packages.sh"
    ]
  }
  provisioner "file" {
    source      = "./db.sql"
    destination = "~/db.sql"
  }

  provisioner "remote-exec" {
    inline = [
      "mysql -u root -p mysql_secure_installation"
      "mysql -u root -p < ~/db.sql"
    ]
  } 
}

