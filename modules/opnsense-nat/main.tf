resource "opnsense_firewall_nat" "this" {
  interface   = var.interface
  protocol    = var.protocol
  enabled     = var.enabled
  disable_nat = var.disable_nat
  log         = var.log
  ip_protocol = var.ip_protocol
  sequence    = var.sequence
  description = var.description

  target = {
    ip   = var.target_ip
    port = var.target_port
  }

  # Only include source block if we have non-default values
  source = var.source_port != null ? {
    net    = var.source_net
    invert = var.source_invert
    port   = var.source_port
  } : {
    net    = var.source_net
    invert = var.source_invert
  }

  # Only include port in destination if specified
  destination = var.destination_port != null ? {
    net    = var.destination_net
    invert = var.destination_invert
    port   = var.destination_port
  } : {
    net    = var.destination_net
    invert = var.destination_invert
  }
}
