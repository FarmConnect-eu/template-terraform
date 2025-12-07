resource "opnsense_interfaces_vlan" "this" {
  description = var.description
  tag         = var.tag
  priority    = var.priority
  parent      = var.parent
  device      = var.device
}
