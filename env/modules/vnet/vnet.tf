// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

resource "azurerm_virtual_network" "vnet" {
  name = var.name
  location = var.location
  resource_group_name = var.resource_group_name
  address_space = var.address_space
}