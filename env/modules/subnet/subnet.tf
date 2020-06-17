// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

resource "azurerm_subnet" "subnet" {
  name = var.name
  resource_group_name = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes = var.address_prefixes

  service_endpoints = var.service_endpoints
}