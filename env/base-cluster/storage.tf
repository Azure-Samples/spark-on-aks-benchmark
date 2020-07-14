# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

resource "random_id" "storage" {
  keepers = {
    storage_id = local.name
  }
  byte_length = 4
}

module "adls_gen2" {
  source = "../modules/storage-account"

  name                     = "${lower(local.name)}${random_id.storage.hex}"
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  hns_enabled              = true

  tags = local.tags
}

module "job_storage" {
  source = "../modules/storage-account"

  name                     = "${lower(local.name)}jobs${random_id.storage.hex}"
  location                 = local.location
  resource_group_name      = azurerm_resource_group.rg.name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  hns_enabled              = false

  tags = local.tags
}

resource "azurerm_storage_container" "jars" {
  name                  = "jars"
  storage_account_name  = module.job_storage.name
  container_access_type = "private"
}