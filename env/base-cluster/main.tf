# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

terraform {
  backend "azurerm" {}
}

data "azurerm_client_config" "current" {}

# Azure RM Provider
provider "azurerm" {
  subscription_id = var.sub
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}
}
provider "azuread" {
  subscription_id = var.sub
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
provider "random" {}

locals {
  name                  = terraform.workspace == "Default" ? "sparkOnAks" : "${terraform.workspace}-sparkOnAks"
  location              = "westus2"
  vnet_address_space    = ["10.10.0.0/16"]
  spark_aks_pool_size   = terraform.workspace == "Default" ? 30 : 3
  spark_cluster_vm_size = "Standard_E16s_v3"
  admin_username        = "azureuser"

  tags = {
    owner    = terraform.workspace
    use_case = "testing"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.name
  location = local.location

  tags = local.tags
}
