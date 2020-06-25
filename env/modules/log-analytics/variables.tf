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
variable "sku" {
  type = string
  default = "PerGB2018"
}
variable "tags" {}