# Azure VPN management

## Introduction

This module manages VPN connectivity in Azure.

## Usage

Instantiate the module by calling it from Terraform like this:

```hcl
module "azure-vpn" {
  source  = "dodevops/vpn/azure"
  version = "<version>"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

The following providers are used by this module:

- azurerm

## Modules

No modules.

## Resources

The following resources are used by this module:

- [azurerm_local_network_gateway.local](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/local_network_gateway) (resource)
- [azurerm_public_ip.publicip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) (resource)
- [azurerm_subnet.gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet) (resource)
- [azurerm_virtual_network.vpnnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network) (resource)
- [azurerm_virtual_network_gateway.vnetgw](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway) (resource)
- [azurerm_virtual_network_gateway_connection.connection](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_gateway_connection) (resource)
- [azurerm_virtual_network_peering.peeringvpn](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) (resource)
- [azurerm_virtual_network_peering.peeringvpnrev](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network_peering) (resource)
- [azurerm_virtual_network.target_vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) (data source)

## Required Inputs

The following input variables are required:

### gatewaynet

Description: IP network to use for the gateway

Type: `string`

### local\_gateway\_ip

Description: IP of the local (on-prem) vpn gateway

Type: `string`

### local\_nets

Description: A list of local (on-prem) IP adress ranges to connect

Type: `list(string)`

### location

Description: The azure location used for azure

Type: `string`

### project

Description: Three letter project key

Type: `string`

### resource\_group

Description: Azure Resource Group to use

Type: `string`

### shared\_key

Description: The preshared key of the connection

Type: `string`

### stage

Description: Stage for this ressource group

Type: `string`

### target\_vnet\_name

Description: Name of the target virtual network

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### ipsec\_policy

Description: IPSec policy to use with the VPN. See the
[Microsoft documentation](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-ipsecikepolicy-rm-powershell)  
for details

Type:

```hcl
list(object({
    dh_group         = string
    ike_encryption   = string
    ike_integrity    = string
    ipsec_encryption = string
    ipsec_integrity  = string
    pfs_group        = string
    sa_lifetime      = number
  }))
```

Default:

```json
[
  {
    "dh_group": "DHGroup2",
    "ike_encryption": "AES256",
    "ike_integrity": "SHA256",
    "ipsec_encryption": "AES256",
    "ipsec_integrity": "SHA256",
    "pfs_group": "None",
    "sa_lifetime": 27000
  }
]
```

### vnetgwsku

Description: SKU to use for the virtual network gateway

Type: `string`

Default: `"VpnGw1"`

## Outputs

The following outputs are exported:

### location

Description: The location input variable (can be used for dependency resolution)

### ppg\_id

Description: The ID of the generated proximity placement group

### resource\_group

Description: The name of the generated resource group
<!-- END_TF_DOCS -->

## Development

Use [terraform-docs](https://terraform-docs.io/) to generate the API documentation by running

    terraform fmt .
    terraform-docs .
