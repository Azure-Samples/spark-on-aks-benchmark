# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

data "azurerm_client_config" "current" {}

# Azure RM Provider
provider "azurerm" {
  features {}
}

provider "random" {}

locals {
  name                  = var.workspace == "default" ? "sparkOnAks" : "${var.workspace}-sparkOnAks"
  location              = "westus2"
  vnet_address_space    = ["10.10.0.0/16"]
  spark_aks_pool_size   = var.workspace == "default" ? 3 : 5
  spark_cluster_vm_size = "Standard_L8s_v2"
  admin_username        = "azureuser"

  tags = {
    owner    = var.workspace
    use_case = "testing"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.name
  location = local.location

  tags = local.tags
}
