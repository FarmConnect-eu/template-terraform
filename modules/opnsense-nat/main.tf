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

  source = merge(
    {
      net    = var.source_net
      invert = var.source_invert
    },
    var.source_port != "" ? { port = var.source_port } : {}
  )

  destination = merge(
    {
      net    = var.destination_net
      invert = var.destination_invert
    },
    var.destination_port != "" ? { port = var.destination_port } : {}
  )
}
