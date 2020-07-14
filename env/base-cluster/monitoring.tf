# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

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