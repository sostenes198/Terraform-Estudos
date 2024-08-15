resource "azurerm_resource_group" "rg" {
  name     = "terraform-rg-vm"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_public_ip" "public_ip" {
  name                = "terraform-public-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = local.common_tags
}

resource "azurerm_network_interface" "network_interface" {
  name                = "terraform-network_interface"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "terraform-public-ip"
    subnet_id                     = data.terraform_remote_state.remote_state.outputs.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = local.common_tags
}

resource "azurerm_network_interface_security_group_association" "nisga" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = data.terraform_remote_state.remote_state.outputs.security_group_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "terraform-vm"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "terraform"
  network_interface_ids = [azurerm_network_interface.network_interface.id]

  admin_ssh_key {
    username   = "terraform"
    public_key = file("./azure-key.pub")
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

  tags = local.common_tags

  connection {
    type        = "ssh"
    user        = "terraform"
    private_key = file("./azure-key")
    host        = self.public_ip_address
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip_address} >> public_ip.txt"
  }

  provisioner "remote-exec" {
    inline = [ 
      "echo subnet_id: ${data.terraform_remote_state.remote_state.outputs.subnet_id} >> /tmp/network_info.txt",
      "echo subnet_id: ${data.terraform_remote_state.remote_state.outputs.security_group_id} >> /tmp/network_info.txt"
     ]
  }

  provisioner "file" {
    content     = "id used: ${self.id}"
    destination = "/tmp/id.txt"
  }
}
