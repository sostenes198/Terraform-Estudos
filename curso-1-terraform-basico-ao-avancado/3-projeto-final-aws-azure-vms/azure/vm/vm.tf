resource "azurerm_public_ip" "public_ip" {
  name                = "terraform-public-ip"
  resource_group_name = module.resource_group.rg_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = var.common_tags
}

resource "azurerm_network_interface" "network_interface" {
  name                = "terraform-network_interface"
  location            = var.location
  resource_group_name = module.resource_group.rg_name

  ip_configuration {
    name                          = "terraform-public-ip"
    subnet_id                     = module.network.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = var.common_tags
}

resource "azurerm_network_interface_security_group_association" "nisga" {
  network_interface_id      = azurerm_network_interface.network_interface.id
  network_security_group_id = module.network.security_group_id
}

resource "null_resource" "generate_ssh_key" {
  provisioner "local-exec" {
    when    = create
    command = "rm -f azure-key && rm -f azure-key.pub && ssh-keygen -t rsa -b 4096 -f azure-key -N \"\""
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  depends_on            = [null_resource.generate_ssh_key]
  name                  = "terraform-vm"
  resource_group_name   = module.resource_group.rg_name
  location              = var.location
  size                  = "Standard_B1s"
  admin_username        = "terraform"
  network_interface_ids = [azurerm_network_interface.network_interface.id]

  admin_ssh_key {
    username   = "terraform"
    public_key = terraform_data.exist_ssh_file.input ? file("${path.module}/${var.ssh_file_name}") : file("${path.module}/default-key.pub")
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

  tags = var.common_tags
}
