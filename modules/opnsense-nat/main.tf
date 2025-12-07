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

  source = {
    net    = var.source_net
    port   = var.source_port
    invert = var.source_invert
  }

  destination = {
    net    = var.destination_net
    port   = var.destination_port
    invert = var.destination_invert
  }
}
