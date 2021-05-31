resource "azurerm_local_network_gateway" "local" {
  address_space       = var.local_nets
  gateway_address     = var.local_gateway_ip
  location            = var.location
  name                = "${lower(var.project)}${lower(var.stage)}netlocalgw"
  resource_group_name = var.resource_group
}

resource "azurerm_virtual_network_gateway_connection" "connection" {
  location                   = var.location
  name                       = "${lower(var.project)}${lower(var.stage)}netvnconnection"
  resource_group_name        = var.resource_group
  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.vnetgw.id
  local_network_gateway_id   = azurerm_local_network_gateway.local.id
  shared_key                 = var.shared_key

  ipsec_policy = var.ipsec_policy
}

data "azurerm_virtual_network" "target_vnet" {
  name                = var.target_vnet_name
  resource_group_name = var.resource_group
}

resource "azurerm_virtual_network_peering" "peeringvpn" {
  name                      = "${lower(var.project)}${lower(var.stage)}netpeering"
  remote_virtual_network_id = data.azurerm_virtual_network.target_vnet.id
  resource_group_name       = var.resource_group
  virtual_network_name      = azurerm_virtual_network.vpnnet.name

  allow_gateway_transit        = true
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
}

resource "azurerm_virtual_network_peering" "peeringvpnrev" {
  name                      = "${lower(var.project)}${lower(var.stage)}netpeeringrev"
  remote_virtual_network_id = azurerm_virtual_network.vpnnet.id
  resource_group_name       = var.resource_group
  virtual_network_name      = var.target_vnet_name

  allow_gateway_transit        = false
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = true
}