resource "azurerm_virtual_network" "vpnnet" {
  address_space = [
    var.gatewaynet
  ]
  location            = var.location
  name                = "${lower(var.project)}${lower(var.stage)}netvnetworkvpn${var.suffix}"
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "gateway" {
  address_prefixes     = [var.gatewaynet]
  name                 = "GatewaySubnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vpnnet.name
}

resource "azurerm_public_ip" "publicip" {
  location            = var.location
  name                = "${lower(var.project)}${lower(var.stage)}ipvpn${var.suffix}"
  resource_group_name = var.resource_group
  allocation_method   = "Dynamic"
}

resource "azurerm_virtual_network_gateway" "vnetgw" {
  location            = var.location
  name                = "${lower(var.project)}${lower(var.stage)}netvirtualgw${var.suffix}"
  resource_group_name = var.resource_group
  sku                 = var.vnetgwsku
  type                = "Vpn"
  ip_configuration {
    subnet_id            = azurerm_subnet.gateway.id
    public_ip_address_id = azurerm_public_ip.publicip.id
  }
}
