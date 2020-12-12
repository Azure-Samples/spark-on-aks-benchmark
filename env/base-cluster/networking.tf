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

resource "azurerm_role_assignment" "aks_sp_network" {
  scope                = module.vnet.id
  role_definition_name = "Network Contributor"
  principal_id         = module.aks.sp_principal_id
}