// Copyright (c) Microsoft Corporation.
// Licensed under the MIT license.

variable "name" {
  type = string
}
variable "location" {
  type = string
}
variable "resource_group_name" {
  type = string
}
variable "account_tier" {
  type = string
}
variable "account_replication_type" {
  type = string
}
variable "account_kind" {
  type = string
  default = "StorageV2"
}
variable "hns_enabled" {
  type = bool
  default = false
}
variable "tags" {}