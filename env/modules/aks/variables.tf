# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license
variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "vm_size" {
  type = string
}
variable "log_analytics_id" {
  type = string
}
variable "vnet_subnet_id" {
  type = string
}

variable "tags" {}