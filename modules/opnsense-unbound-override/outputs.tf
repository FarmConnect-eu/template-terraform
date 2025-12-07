output "id" {
  description = "The UUID of the host override"
  value       = opnsense_unbound_host_override.this.id
}

output "fqdn" {
  description = "The fully qualified domain name"
  value       = "${var.hostname}.${var.domain}"
}

output "override_summary" {
  description = "Summary of the host override configuration"
  value = {
    id          = opnsense_unbound_host_override.this.id
    fqdn        = "${var.hostname}.${var.domain}"
    type        = var.type
    server      = var.type != "MX" ? var.server : null
    mx_host     = var.type == "MX" ? var.mx_host : null
    mx_priority = var.type == "MX" ? var.mx_priority : null
    enabled     = var.enabled
    description = var.description
  }
}
