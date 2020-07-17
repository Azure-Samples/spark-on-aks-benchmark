output "acr_name" {
  value = azurerm_container_registry.acr.name
}

output "aks_name" {
  value = module.aks.name
}

output "rg_name" {
  value = azurerm_resource_group.rg.name
}