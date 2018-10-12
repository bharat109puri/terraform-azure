resource "azurerm_network_security_group" "sev1234" {
  name                = "bharat_vmsg"
  location            = "eastus"
  resource_group_name = "${azurerm_resource_group.bharat_group.name}"

  security_rule {
    name                       = "Inter-communication"
    description                = "Inter-communication"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.10.10.10/32"
    destination_address_prefix = "*"
  }
}
