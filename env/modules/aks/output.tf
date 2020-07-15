# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

output "id" {
  value = azurerm_kubernetes_cluster.aks.id
}
output "aks_aad_object_id" {
  value = azuread_service_principal.aks_sp.object_id
}