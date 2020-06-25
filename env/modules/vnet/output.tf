# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

output "id" {
  value = azurerm_virtual_network.vnet.id
}
output "name" {
  value = azurerm_virtual_network.vnet.name
}