# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

resource "random_id" "aks" {
  keepers = {
    aks = var.name
  }

  byte_length = 4
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "${var.name}-k8s"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name}-k8s"

  # enable_pod_security_policy = true

  role_based_access_control {
    enabled = true
  }

  sku_tier = "Paid"

  default_node_pool {
    name           = "default"
    node_count     = var.node_count
    vm_size        = var.vm_size
    vnet_subnet_id = var.vnet_subnet_id
  }

  network_profile {
    network_plugin = "azure"
  }

  identity {
    type = "SystemAssigned"
  }

  addon_profile {
    oms_agent {
      enabled                    = true
      log_analytics_workspace_id = var.log_analytics_id
    }
    kube_dashboard {
      enabled = true
    }
  }

  tags = var.tags
}
