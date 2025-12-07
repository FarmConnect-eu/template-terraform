resource "opnsense_firewall_filter" "this" {
  enabled     = var.enabled
  sequence    = var.sequence
  description = var.description

  interface = {
    interface = var.interfaces
    invert    = var.interface_invert
  }

  filter = {
    quick     = var.quick
    action    = var.action
    direction = var.direction
    protocol  = var.protocol

    source = var.source_net != null ? {
      net    = var.source_net
      port   = var.source_port
      invert = var.source_invert
    } : null

    destination = var.destination_net != null ? {
      net    = var.destination_net
      port   = var.destination_port
      invert = var.destination_invert
    } : null

    log = var.log
  }
}
