output "id" {
  description = "The ID of the zone"
  value       = powerdns_zone.this.id
}

output "name" {
  description = "The name of the zone (normalized with trailing dot)"
  value       = powerdns_zone.this.name
}

output "kind" {
  description = "The kind of the zone"
  value       = powerdns_zone.this.kind
}

output "nameservers" {
  description = "The zone nameservers"
  value       = var.kind != "Slave" ? local.nameservers : null
}

output "zone_summary" {
  description = "Summary of the zone configuration"
  value = {
    id          = powerdns_zone.this.id
    name        = powerdns_zone.this.name
    kind        = powerdns_zone.this.kind
    nameservers = var.kind != "Slave" ? local.nameservers : null
    masters     = var.kind == "Slave" ? var.masters : null
    account     = var.account
  }
}
