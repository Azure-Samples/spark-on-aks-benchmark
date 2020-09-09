# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}

output "name" {
  value = azurerm_kubernetes_cluster.aks.name
}

output "sp_principal_id" {
  value = azurerm_kubernetes_cluster.aks.identity[0].principal_id
}