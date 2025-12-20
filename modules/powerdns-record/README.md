# powerdns-record

Terraform module for creating DNS records in PowerDNS with automatic A and PTR record management.

## Overview

Creates and manages DNS records in PowerDNS:
- A records with automatic FQDN normalization
- CNAME records
- Optional PTR (reverse DNS) records for A records
- Automatic trailing dot handling

## Usage

### A Record Only

```hcl
module "dns_postgres" {
  source = "../../template-terraform/modules/powerdns-record"

  zone    = "farmconnect.local"
  name    = "svc-postgres-1.farmconnect.local"
  type    = "A"
  content = "10.10.20.121"
}
```

### A Record with PTR (Reverse DNS)

```hcl
module "dns_nfs" {
  source = "../../template-terraform/modules/powerdns-record"

  zone         = "farmconnect.local"
  name         = "svc-nfs-1.farmconnect.local"
  type         = "A"
  content      = "10.10.20.120"
  ttl          = 300

  create_ptr   = true
  reverse_zone = "20.10.10.in-addr.arpa"
}
```

### CNAME Record

```hcl
module "dns_alias" {
  source = "../../template-terraform/modules/powerdns-record"

  zone    = "farmconnect.local"
  name    = "db.farmconnect.local"
  type    = "CNAME"
  content = "svc-postgres-1.farmconnect.local."
}
```

### With VM Module Integration

```hcl
module "vm" {
  source = "../../template-terraform/modules/proxmox-debian-vm"
  # ... VM configuration
}

module "dns" {
  source = "../../template-terraform/modules/powerdns-record"

  zone         = "farmconnect.local"
  name         = "${module.vm.vm_name}.farmconnect.local"
  type         = "A"
  content      = module.vm.ipv4_address
  create_ptr   = true
  reverse_zone = "20.10.10.in-addr.arpa"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| powerdns | ~> 1.5.0 |

## Provider Configuration

```hcl
provider "powerdns" {
  api_key    = var.powerdns_api_key
  server_url = var.powerdns_server_url  # e.g., http://10.10.20.124:8081
}
```

## Inputs

### Required

| Name | Description | Type |
|------|-------------|------|
| `zone` | DNS zone name (e.g., `farmconnect.local`) | `string` |
| `name` | Full DNS record name (FQDN) | `string` |
| `content` | Record content (IP for A, hostname for CNAME) | `string` |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `type` | Record type (`A`, `CNAME`, `PTR`) | `string` | `"A"` |
| `ttl` | Time to live in seconds (60-86400) | `number` | `300` |
| `create_ptr` | Create PTR record (A records only) | `bool` | `false` |
| `reverse_zone` | Reverse DNS zone for PTR records | `string` | `""` |

## Outputs

| Name | Description |
|------|-------------|
| `record_id` | PowerDNS record ID |
| `fqdn` | Fully qualified domain name (with trailing dot) |
| `zone_fqdn` | Zone FQDN (with trailing dot) |
| `ip_address` | IP address (for A records) |
| `ptr_record_id` | PTR record ID (if created) |
| `ptr_fqdn` | PTR record FQDN (if created) |
| `record_summary` | Summary object with all record details |

## FQDN Normalization

The module automatically handles trailing dots:

| Input | Normalized |
|-------|------------|
| `farmconnect.local` | `farmconnect.local.` |
| `farmconnect.local.` | `farmconnect.local.` |
| `host.farmconnect.local` | `host.farmconnect.local.` |

## PTR Record Generation

For A record `10.10.20.122` in zone `20.10.10.in-addr.arpa`:

```
PTR Name: 122.20.10.10.in-addr.arpa.
PTR Content: svc-postgres-1.farmconnect.local.
```

### VLAN to Reverse Zone Mapping

| VLAN | Network | Reverse Zone |
|------|---------|--------------|
| 10 (DMZ) | 10.10.10.0/24 | `10.10.10.in-addr.arpa` |
| 20 (Services) | 10.10.20.0/24 | `20.10.10.in-addr.arpa` |
| 30 (Management) | 10.10.30.0/24 | `30.10.10.in-addr.arpa` |
| 40 (Pipeline) | 10.10.40.0/24 | `40.10.10.in-addr.arpa` |

## Complete Example

```hcl
terraform {
  required_providers {
    powerdns = {
      source  = "pan-net/powerdns"
      version = "~> 1.5.0"
    }
  }
}

provider "powerdns" {
  api_key    = var.powerdns_api_key
  server_url = var.powerdns_server_url
}

# Services VLAN DNS records
module "dns_postgres" {
  source = "../../template-terraform/modules/powerdns-record"

  zone         = "farmconnect.local"
  name         = "svc-postgres-1.farmconnect.local"
  type         = "A"
  content      = "10.10.20.121"
  ttl          = 300
  create_ptr   = true
  reverse_zone = "20.10.10.in-addr.arpa"
}

module "dns_nfs" {
  source = "../../template-terraform/modules/powerdns-record"

  zone         = "farmconnect.local"
  name         = "svc-nfs-1.farmconnect.local"
  type         = "A"
  content      = "10.10.20.120"
  create_ptr   = true
  reverse_zone = "20.10.10.in-addr.arpa"
}

# CNAME alias
module "dns_db_alias" {
  source = "../../template-terraform/modules/powerdns-record"

  zone    = "farmconnect.local"
  name    = "db.farmconnect.local"
  type    = "CNAME"
  content = "svc-postgres-1.farmconnect.local."
}

output "postgres_fqdn" {
  value = module.dns_postgres.fqdn
}
```

## Prerequisites

1. PowerDNS server running (e.g., `svc-powerdns-1`)
2. Forward zone created in PowerDNS (`farmconnect.local`)
3. Reverse zones created if using PTR records (`X.10.10.in-addr.arpa`)
4. API key configured with write permissions

## Validation

The module validates:
- Zone names must be valid DNS zone format
- Record names must be valid DNS hostname format
- Record type must be `A`, `CNAME`, or `PTR`
- TTL must be between 60 and 86400 seconds
- Reverse zone must be valid `in-addr.arpa` format
