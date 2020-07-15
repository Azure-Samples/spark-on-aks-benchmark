# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

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

resource "azurerm_role_assignment" "aks_sp_network" {
  scope                = module.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.aks_aad_object_id
}