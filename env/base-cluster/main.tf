
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

terraform {
  backend "azurerm" {}
}

# Azure RM Provider
provider "azurerm" {
  subscription_id = var.sub
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  features {}

}

locals {
  name                  = "sparkOnAks"
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

resource "random_id" "storage" {
  keepers = {
    storage_id = local.name
  }
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name     = local.name
  location = local.location

  tags = local.tags
}

module "vnet" {
  source = "../modules/vnet"

  name                = local.name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = local.vnet_address_space

  tags = local.tags
}

module "aks_subnet" {
  source = "../modules/subnet"

  name                 = "aks_subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.10.0.0/21"]

  service_endpoints = ["Microsoft.ContainerRegistry"]

}

module "vm_subnet" {
  source = "../modules/subnet"

  name                 = "vms"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.10.8.0/24"]

  service_endpoints = ["Microsoft.ContainerRegistry"]
}

module "bastion_subnet" {
  source = "../modules/subnet"

  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes     = ["10.10.9.224/27"]

  service_endpoints = ["Microsoft.ContainerRegistry"]
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastion_pip"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

module "producer_vm" {
  source = "../modules/vm"

  name                = "producer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  vm_size             = "Standard_D4s_v3"
  admin_username      = local.admin_username
  subnet_id           = module.vm_subnet.id
  public_key          = var.public_key
  tags                = local.tags
}

module "log_analytics" {
  source = "../modules/log-analytics"

  name                = "${lower(local.name)}${random_id.storage.hex}"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = local.tags
}

resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = local.location
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = module.log_analytics.id
  workspace_name        = module.log_analytics.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

module "aks" {
  source = "../modules/aks"

  name                = local.name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = "Standard_D4s_v3"
  log_analytics_id    = module.log_analytics.id
  vnet_subnet_id      = module.aks_subnet.id

  tags = local.tags
}

module "spark_node_pool" {
  source = "../modules/aks-node-pool"

  name           = "spark"
  aks_cluster_id = module.aks.id
  vm_size        = local.spark_cluster_vm_size
  node_count     = local.spark_aks_pool_size
  vnet_subnet_id = module.aks_subnet.id
  node_labels = {
    "app" : "spark",
  }

  tags = local.tags
}

resource "azurerm_container_registry" "acr" {
  name                = "${lower(local.name)}${random_id.storage.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  sku                 = "Premium"
  admin_enabled       = false

  network_rule_set {
    virtual_network {
      action    = "Allow"
      subnet_id = module.aks_subnet.id
    }
  }

  tags = local.tags
}

module "adls_gen2" {
  source = "../modules/storage-account"

  name                     = "${lower(local.name)}${random_id.storage.hex}"
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  hns_enabled              = true

  tags = local.tags
}

module "job_storage" {
  source = "../modules/storage-account"

  name                     = "${lower(local.name)}jobs${random_id.storage.hex}"
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  hns_enabled              = false

  tags = local.tags
}

resource "azurerm_storage_container" "jars" {
  name                  = "jars"
  storage_account_name  = module.job_storage.name
  container_access_type = "private"
}
