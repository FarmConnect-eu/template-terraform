resource "opnsense_firewall_alias" "this" {
  name        = var.name
  type        = var.type
  content     = toset(var.content)
  description = var.description
  enabled     = var.enabled
  stats       = var.stats
  categories  = toset(var.categories)
  ip_protocol = contains(["asn", "geoip", "external"], var.type) ? toset(var.ip_protocol) : null
  update_freq = var.type == "urltable" ? var.update_freq : null
  interface   = var.type == "dynipv6host" ? var.interface : null
}
