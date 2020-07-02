# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

# Provider block variables set as GitHub secrets at action time
variable "sub" {
  type = string
}
variable "client_id" {
  type = string
}
variable "client_secret" {
  type = string
}
variable "tenant_id" {
  type = string
}
variable "public_key" {
  type = string
}
