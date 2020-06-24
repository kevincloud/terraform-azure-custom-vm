resource "azurerm_public_ip" "public-ip" {
    name                         = "${var.identifier}-public-ip"
    location                     = var.location
    resource_group_name          = var.res_group_name
    allocation_method            = "Dynamic"

    tags = var.tags
}

resource "azurerm_network_interface" "nic" {
    name                        = "${var.identifier}-nic"
    location                    = var.location
    resource_group_name         = var.res_group_name

    ip_configuration {
        name                          = "kcNicConfiguration"
        subnet_id                     = var.subnet_id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.public-ip.id
    }

    tags = var.tags
}

resource "azurerm_virtual_machine" "azure-vm" {
    name                  = "${var.identifier}-vm"
    location              = var.location
    resource_group_name   = var.res_group_name
    network_interface_ids = [azurerm_network_interface.nic.id]
    vm_size               = var.vm_size

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name              = "kcOsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name  = var.identifier
        admin_username = var.linux_user
        admin_password = var.linux_password
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled     = "true"
        storage_uri = var.storage_endpoint
    }

    tags = var.tags
}

data "azurerm_public_ip" "public-ip" {
    name                = azurerm_public_ip.public-ip.name
    resource_group_name = var.res_group_name
    depends_on = [azurerm_public_ip.public-ip]
}
