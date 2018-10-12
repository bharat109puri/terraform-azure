resource "azurerm_resource_group" "bharat_group" {
    name     = "bharat_ResourceGroup"
    location = "eastus"

    tags {
        environment = "Terraform Demo"
    }
}

resource "azurerm_virtual_network" "bharat_network" {
    name                = "bharat_Vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = "${azurerm_resource_group.bharat_group.name}"

    tags {
        environment = "Terraform Demo"
    }
}

resource "azurerm_subnet" "bharat_subnet1" {
    name                 = "bharat_Subnet1"
    resource_group_name  = "${azurerm_resource_group.bharat_group.name}"
    virtual_network_name = "${azurerm_virtual_network.bharat_network.name}"
    address_prefix       = "10.0.1.0/24"
}

resource "azurerm_subnet" "bharat_subnet2" {
    name                 = "bharat_Subnet2"
    resource_group_name  = "${azurerm_resource_group.bharat_group.name}"
    virtual_network_name = "${azurerm_virtual_network.bharat_network.name}"
    address_prefix       = "10.0.2.0/24"
}
