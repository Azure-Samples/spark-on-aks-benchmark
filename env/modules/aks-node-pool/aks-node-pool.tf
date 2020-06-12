resource "azurerm_kubernetes_cluster_node_pool" "pool" {
  name = "${var.name}pool"
  kubernetes_cluster_id = var.aks_cluster_id
  vm_size = var.vm_size
  node_count = var.node_count
  vnet_subnet_id = var.vnet_subnet_id
  mode = "User"

  tags = var.tags
}