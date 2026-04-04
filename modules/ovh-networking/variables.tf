variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: staging or prod"
  type        = string
}

variable "service_prefix" {
  description = "Service name prefix for resource naming (e.g. myproject)"
  type        = string
}

variable "region" {
  description = "OVH region (GRA9 for Gravelines)"
  type        = string
  default     = "GRA9"
}

variable "networks" {
  description = "Map of private networks to create. Key is the network name, value contains VLAN ID and subnet config."
  type = map(object({
    vlan_id    = number
    cidr       = string
    dhcp_start = string
    dhcp_end   = string
  }))
}

variable "gateway_network_key" {
  description = "Key from var.networks on which to attach the gateway. Empty string to skip gateway creation."
  type        = string
  default     = ""
}

variable "gateway_model" {
  description = "Gateway model size (s, m, l)"
  type        = string
  default     = "s"
}
