locals {
  # Normalize zone name to always end with a dot (PowerDNS requirement)
  zone_name = endswith(var.name, ".") ? var.name : "${var.name}."

  # Normalize nameservers
  nameservers = [for ns in var.nameservers : endswith(ns, ".") ? ns : "${ns}."]
}

resource "powerdns_zone" "this" {
  name         = local.zone_name
  kind         = var.kind
  nameservers  = var.kind != "Slave" ? local.nameservers : null
  masters      = var.kind == "Slave" ? var.masters : null
  account      = var.account
  soa_edit_api = var.soa_edit_api
}
