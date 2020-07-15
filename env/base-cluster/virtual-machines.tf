# Copyright (c) Microsoft Corporation.
# Licensed under the MIT license

resource "azurerm_bastion_host" "bastion" {
  name                = "bastion"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name
  ip_configuration {
    name                 = "configuration"
    subnet_id            = module.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }
}

module "producer_vm" {
  source = "../modules/vm"

  name                = "producer"
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  vm_size             = "Standard_D4s_v3"
  admin_username      = local.admin_username
  subnet_id           = module.vm_subnet.id
  public_key          = var.public_key
  tags                = local.tags
}