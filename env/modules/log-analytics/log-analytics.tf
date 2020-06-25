# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

resource "azurerm_log_analytics_workspace" "la" {
  name = "${var.name}-la"
  location = var.location
  resource_group_name = var.resource_group_name
  sku = var.sku

  tags = var.tags
}