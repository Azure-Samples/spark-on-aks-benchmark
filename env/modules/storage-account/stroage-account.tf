# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

resource "azurerm_storage_account" "stroage" {
  name = var.name
  resource_group_name = var.resource_group_name
  location = var.location
  account_tier = var.account_tier
  account_replication_type = var.account_replication_type
  account_kind = var.account_kind
  is_hns_enabled = var.hns_enabled

  tags = var.tags

  identity {
    type = "SystemAssigned"
  }
}