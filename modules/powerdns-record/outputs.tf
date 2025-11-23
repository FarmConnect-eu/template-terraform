output "record_id" {
  description = "PowerDNS record ID"
  value       = var.type == "A" ? try(powerdns_record.a_record[0].id, "") : (var.type == "CNAME" ? try(powerdns_record.cname_record[0].id, "") : "")
}

output "fqdn" {
  description = "Fully qualified domain name (normalized with trailing dot)"
  value       = local.name_fqdn
}

output "zone_fqdn" {
  description = "Zone FQDN (normalized with trailing dot)"
  value       = local.zone_fqdn
}

output "ip_address" {
  description = "IP address (for A records)"
  value       = var.type == "A" ? var.content : null
}

output "ptr_record_id" {
  description = "PTR record ID (if created)"
  value       = var.create_ptr && var.type == "A" ? try(powerdns_record.ptr_record[0].id, "") : null
}

output "ptr_fqdn" {
  description = "PTR record FQDN (if created)"
  value       = var.create_ptr && var.type == "A" ? local.ptr_name : null
}

output "record_summary" {
  description = "Summary of DNS record configuration"
  value = {
    zone         = local.zone_fqdn
    name         = local.name_fqdn
    type         = var.type
    content      = var.content
    ttl          = var.ttl
    ptr          = var.create_ptr
    reverse_zone = var.create_ptr ? local.reverse_zone_fqdn : null
    ptr_name     = var.create_ptr ? local.ptr_name : null
  }
}
