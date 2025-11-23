# Locals for DNS FQDN normalization and reverse DNS calculation
locals {
  # Normalize zone and name to always end with a dot (PowerDNS requirement)
  zone_fqdn = endswith(var.zone, ".") ? var.zone : "${var.zone}."
  name_fqdn = endswith(var.name, ".") ? var.name : "${var.name}."

  # Normalize reverse zone for PTR records
  reverse_zone_fqdn = var.reverse_zone != "" ? (endswith(var.reverse_zone, ".") ? var.reverse_zone : "${var.reverse_zone}.") : ""

  # Extract IP octets for PTR record
  ip_parts = split(".", var.content)

  # PTR name format: <last-octet>.<third-octet>.<second-octet>.<first-octet>.in-addr.arpa.
  # For 10.10.20.122 in zone 20.10.10.in-addr.arpa -> 122.20.10.10.in-addr.arpa.
  ptr_name = var.create_ptr && var.type == "A" ? format(
    "%s.%s.%s.%s.in-addr.arpa.",
    local.ip_parts[3],
    local.ip_parts[2],
    local.ip_parts[1],
    local.ip_parts[0]
  ) : ""
}

# PowerDNS A Record
resource "powerdns_record" "a_record" {
  count = var.type == "A" ? 1 : 0

  zone    = local.zone_fqdn
  name    = local.name_fqdn
  type    = "A"
  ttl     = var.ttl
  records = [var.content]
}

# PowerDNS PTR Record (Reverse DNS)
resource "powerdns_record" "ptr_record" {
  count = var.create_ptr && var.type == "A" ? 1 : 0

  zone    = local.reverse_zone_fqdn
  name    = local.ptr_name
  type    = "PTR"
  ttl     = var.ttl
  records = [local.name_fqdn]
}

# PowerDNS CNAME Record
resource "powerdns_record" "cname_record" {
  count = var.type == "CNAME" ? 1 : 0

  zone    = local.zone_fqdn
  name    = local.name_fqdn
  type    = "CNAME"
  ttl     = var.ttl
  records = [var.content]
}
