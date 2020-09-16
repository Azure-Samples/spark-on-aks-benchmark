# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

module "aks" {
  source = "../modules/aks"

  name                = local.name
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size             = local.spark_cluster_vm_size
  log_analytics_id    = module.log_analytics.id
  vnet_subnet_id      = module.aks_subnet.id
  node_count = local.spark_aks_pool_size
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
  name                = "sparkacr${random_id.storage.hex}"
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

  depends_on = [module.aks_subnet]
}

resource "azurerm_role_assignment" "acr" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  principal_id         = module.aks.sp_principal_id

  depends_on = [
    azurerm_container_registry.acr,

  ]
}

resource "azurerm_role_assignment" "cd_push" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "acrpush"
  principal_id         = data.azurerm_client_config.current.object_id

  depends_on = [
    azurerm_container_registry.acr,
  ]
}
