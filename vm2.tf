# Create a Public IP for the Virtual Machine
resource "azurerm_public_ip" "bharat_pip2" {
  name                         = "bharat_pip2"
  location                     = "eastus"
  resource_group_name          = "${azurerm_resource_group.bharat_group.name}"
  public_ip_address_allocation = "dynamic"
}

resource "azurerm_network_interface" "bharatvm2_eni0" {
  name                      = "bharatvm2_eni0"
  location                  = "eastus"
  resource_group_name       = "${azurerm_resource_group.bharat_group.name}"
  network_security_group_id = "${azurerm_network_security_group.sev1234.id}"
  ip_configuration {
    name                          = "primary"
    subnet_id                     = "${azurerm_subnet.bharat_subnet1.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.bharat_pip2.id}"
  }
}

# Create the second network interface card for internal - no PIP and no NSG on this one
resource "azurerm_network_interface" "bharatvm2_eni1" {
  name                      = "bharatvm2_eni1"
  location                  = "eastus"
  resource_group_name       = "${azurerm_resource_group.bharat_group.name}"
  network_security_group_id = "${azurerm_network_security_group.sev1234.id}"
  ip_configuration {
    name                          = "eni1-ip1"
    subnet_id                     = "${azurerm_subnet.bharat_subnet1.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.1.20"
  }
}

resource "azurerm_network_interface" "bharatvm2_eni2" {
  name                      = "bharatvm2_eni2"
  location                  = "eastus"
  resource_group_name       = "${azurerm_resource_group.bharat_group.name}"
  network_security_group_id = "${azurerm_network_security_group.sev1234.id}"
  ip_configuration {
    name                          = "eni1-ip2"
    subnet_id                     = "${azurerm_subnet.bharat_subnet2.id}"
    private_ip_address_allocation = "static"
    private_ip_address            = "10.0.2.20"
  }
}

resource "azurerm_virtual_machine" "bharatvm2" {
  name                  = "bharatvm2"
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.bharat_group.name}"
  primary_network_interface_id = "${azurerm_network_interface.bharatvm2_eni0.id}"
  network_interface_ids = ["${azurerm_network_interface.bharatvm2_eni0.id}","${azurerm_network_interface.bharatvm2_eni1.id}","${azurerm_network_interface.bharatvm2_eni2.id}"]
  vm_size               = "Standard_B2s"

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "bharatvm2-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "bharat"
    admin_username = "bharat"
    admin_password = "adminPassword@123"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}
