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

  dynamic "ipsec_policy" {
    for_each = var.ipsec_policy
    content {
      dh_group = ipsec_policy.value["dh_group"]
      ike_encryption = ipsec_policy.value["ike_encryption"]
      ike_integrity = ipsec_policy.value["ike_integrity"]
      ipsec_encryption = ipsec_policy.value["ipsec_encryption"]
      ipsec_integrity = ipsec_policy.value["ipsec_integrity"]
      pfs_group = ipsec_policy.value["pfs_group"]
    }
  }
}

resource "azurerm_virtual_network_peering" "peeringvpn" {
  name                      = "${lower(var.project)}${lower(var.stage)}netpeering"
  remote_virtual_network_id = var.target_vnet.id
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
  virtual_network_name      = var.target_vnet.name

  allow_gateway_transit        = false
  allow_forwarded_traffic      = true
  allow_virtual_network_access = true
  use_remote_gateways          = true

  depends_on = [azurerm_virtual_network_gateway.vnetgw]
}
