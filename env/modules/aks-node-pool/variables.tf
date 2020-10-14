# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

variable "name" {
  type = string
}
variable "aks_cluster_id" {
  type = string
}
variable "vm_size" {
  type = string
}
variable "os_disk_size" {
  type = number
}
variable "node_count" {
  type = number
}
variable "vnet_subnet_id" {
  type = string
}
variable "node_labels" {
  default = null
}
variable "tags" {}
