variable "location" {
  type        = string
  description = "The azure location used for azure"
}

variable "project" {
  type        = string
  description = "Three letter project key"
}

variable "stage" {
  type        = string
  description = "Stage for this ressource group"
}

variable "gatewaynet" {
  type        = string
  description = "IP network to use for the gateway"
}

variable "resource_group" {
  type        = string
  description = "Azure Resource Group to use"
}

variable "vnetgwsku" {
  type        = string
  description = "SKU to use for the virtual network gateway"
  default     = "VpnGw1"
}

variable "target_vnet" {
  type        = object({
    id = string
    name = string
  })
  description = "The Terraform resource of the target vnet"
}

variable "local_nets" {
  type        = list(string)
  description = "A list of local (on-prem) IP adress ranges to connect"
}

variable "local_gateway_ip" {
  type        = string
  description = "IP of the local (on-prem) vpn gateway"
}

variable "shared_key" {
  type        = string
  description = "The preshared key of the connection"
}

variable "ipsec_policy" {
  type = list(object({
    dh_group         = string
    ike_encryption   = string
    ike_integrity    = string
    ipsec_encryption = string
    ipsec_integrity  = string
    pfs_group        = string
    sa_lifetime      = number
  }))
  default = [{
    dh_group         = "DHGroup2"
    ike_encryption   = "AES256"
    ike_integrity    = "SHA256"
    ipsec_encryption = "AES256"
    ipsec_integrity  = "SHA256"
    pfs_group        = "None"
    sa_lifetime      = 27000
  }]
  description = <<-EOL
  IPSec policy to use with the VPN. See the
  [Microsoft documentation](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-ipsecikepolicy-rm-powershell)
  for details
  EOL
}
