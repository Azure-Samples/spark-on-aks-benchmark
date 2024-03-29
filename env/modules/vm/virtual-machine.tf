resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = var.tags
}

resource "azurerm_network_interface" "nic" {
  name                = "${var.name}-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_virtual_machine_extension" "extension" {
  name = "config"
  virtual_machine_id = azurerm_linux_virtual_machine.vm.id
  publisher = "Microsoft.Azure.Extensions"
  type = "CustomScript"
  type_handler_version = "2.1"

  settings = <<SETTINGS
    {
        "script": "${base64encode(templatefile("../modules/vm/config.sh", {
          vmname="${azurerm_linux_virtual_machine.vm.name}"
        }))}"
    }
SETTINGS
  depends_on = [azurerm_linux_virtual_machine.vm]
  tags = var.tags
}