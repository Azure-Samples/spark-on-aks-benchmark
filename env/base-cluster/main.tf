provider azurerm {
  features{}
}

locals {
  name = "sparkOnAks"
  location = "westus2"
  vnet_address_space = ["10.10.0.0/16"]
  tags = {
    owner = terraform.workspace
    use_case = "testing"
  }
}

resource "random_id" "storage" {
  keepers = {
    storage_id = local.name
  }
  byte_length = 4
}

resource "azurerm_resource_group" "rg" {
  name = local.name
  location = local.location

  tags = local.tags
}

module "vnet" {
  source = "../modules/vnet"

  name = local.name
  location = local.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space = local.vnet_address_space

  tags = local.tags
}

module "aks_subnet" {
  source = "../modules/subnet"

  name = "aks_subnet"
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = module.vnet.name
  address_prefixes = ["10.10.1.0/24"]
}

module "log_analytics" {
  source = "../modules/log-analytics"

  name = local.name
  location = local.location
  resource_group_name = azurerm_resource_group.rg.name
  
  tags = local.tags
}

resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name = "ContainerInsights"
  location = local.location
  resource_group_name = azurerm_resource_group.rg.name
  workspace_resource_id = module.log_analytics.id
  workspace_name = module.log_analytics.name

  plan{
    publisher = "Microsoft"
    product = "OMSGallery/ContainerInsights"
  }
}

module "aks" {
  source = "../modules/aks"

  name = local.name
  location = local.location
  resource_group_name = azurerm_resource_group.rg.name
  vm_size = "Standard_D4s_v3"
  log_analytics_id = module.log_analytics.id
  vnet_subnet_id = module.aks_subnet.id

  tags = local.tags
}

module "spark_node_pool" {
  source = "../modules/aks-node-pool"

  name = "spark"
  aks_cluster_id = module.aks.id
  vm_size = "Standard_D4s_v3"
  node_count = 3
  vnet_subnet_id = module.aks_subnet.id
  
  tags = local.tags
}

resource "azurerm_container_registry" "acr" {
  name                     = local.name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = local.location
  sku                      = "Premium"
  admin_enabled            = false

  tags = local.tags
}