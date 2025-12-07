resource "opnsense_unbound_host_override" "this" {
  hostname    = var.hostname
  domain      = var.domain
  type        = var.type
  enabled     = var.enabled
  description = var.description

  # A or AAAA records
  server = var.type != "MX" ? var.server : null

  # MX records
  mx_host     = var.type == "MX" ? var.mx_host : null
  mx_priority = var.type == "MX" ? var.mx_priority : null
}
