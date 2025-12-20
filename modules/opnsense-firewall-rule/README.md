# opnsense-firewall-rule

Terraform module for managing OPNsense firewall filter rules via the OPNsense API.

## Overview

Creates and manages firewall rules in OPNsense:
- Pass, block, or reject actions
- Interface and direction control
- Source/destination network and port filtering
- Rule sequencing for priority control
- Logging support

## Usage

### Allow TCP Traffic

```hcl
module "allow_ssh" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description      = "Allow SSH from Pipeline to Services"
  sequence         = 100
  interfaces       = ["opt4"]  # Pipeline VLAN
  protocol         = "TCP"
  source_net       = "10.10.40.0/24"
  destination_net  = "NET_SERVICES"
  destination_port = "22"
  log              = true
}
```

### Allow Any Protocol

```hcl
module "allow_icmp" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description     = "Allow ICMP from Pipeline to DMZ"
  sequence        = 120
  interfaces      = ["opt4"]
  protocol        = "ICMP"
  source_net      = "10.10.40.0/24"
  destination_net = "NET_DMZ"
}
```

### Block Traffic

```hcl
module "block_external" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description     = "Block Services to Internet"
  sequence        = 200
  interfaces      = ["opt2"]  # Services VLAN
  action          = "block"
  source_net      = "NET_SERVICES"
  destination_net = "any"
  log             = true
}
```

### Using Aliases

```hcl
module "allow_dns" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description      = "Allow Pipeline DNS to PowerDNS"
  sequence         = 102
  interfaces       = ["opt4"]
  protocol         = "UDP"
  source_net       = "NET_PIPELINE"
  destination_net  = "NET_SERVICES"
  destination_port = "53"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| opnsense | >= 0.10.0 |

## Provider Configuration

```hcl
provider "opnsense" {
  uri              = var.opnsense_uri      # e.g., https://10.10.10.1:8443
  api_key          = var.opnsense_api_key
  api_secret       = var.opnsense_api_secret
  allow_unverified = true
}
```

## Inputs

### Required

| Name | Description | Type |
|------|-------------|------|
| `description` | Rule description | `string` |
| `interfaces` | Interfaces to apply rule on | `list(string)` |

### Optional - Rule Control

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `enabled` | Enable this rule | `bool` | `true` |
| `sequence` | Rule order (lower = higher priority) | `number` | `100` |
| `action` | `pass`, `block`, `reject` | `string` | `"pass"` |
| `direction` | `in`, `out` | `string` | `"in"` |
| `quick` | Stop processing on match | `bool` | `true` |
| `log` | Log matching packets | `bool` | `false` |

### Optional - Protocol

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `protocol` | `any`, `TCP`, `UDP`, `TCP/UDP`, `ICMP`, etc. | `string` | `"any"` |

### Optional - Source

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `source_net` | Source network/alias (`any`, CIDR, alias) | `string` | `null` |
| `source_port` | Source port(s) | `string` | `""` |
| `source_invert` | Invert source match | `bool` | `false` |

### Optional - Destination

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `destination_net` | Destination network/alias | `string` | `null` |
| `destination_port` | Destination port(s) | `string` | `""` |
| `destination_invert` | Invert destination match | `bool` | `false` |

### Optional - Interface

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `interface_invert` | Apply to all but selected interfaces | `bool` | `false` |

## Outputs

| Name | Description |
|------|-------------|
| `id` | UUID of the firewall rule |

## Interface Naming

OPNsense interface names (from Interfaces → Assignments):

| VLAN | Network | Interface Name |
|------|---------|----------------|
| 10 (DMZ) | 10.10.10.0/24 | `opt1` |
| 20 (Services) | 10.10.20.0/24 | `opt2` |
| 30 (Management) | 10.10.30.0/24 | `opt3` |
| 40 (Pipeline) | 10.10.40.0/24 | `opt4` |
| WAN | External | `wan` |
| LAN | Default | `lan` |

## Built-in Aliases

FarmConnect uses these OPNsense aliases:

| Alias | Value | Description |
|-------|-------|-------------|
| `NET_DMZ` | 10.10.10.0/24 | DMZ zone |
| `NET_SERVICES` | 10.10.20.0/24 | Services zone |
| `NET_MGMT` | 10.10.30.0/24 | Management zone |
| `NET_PIPELINE` | 10.10.40.0/24 | Pipeline zone |

## Sequence Guidelines

| Range | Purpose |
|-------|---------|
| 1-99 | Critical/emergency rules |
| 100-199 | Service-specific rules |
| 200-299 | General access rules |
| 300-399 | Monitoring/logging rules |
| 900-999 | Default deny rules |

## Complete Example

```hcl
locals {
  pipeline_interface = "opt4"
  pipeline_net       = "10.10.40.0/24"
}

# Allow Pipeline to OPNsense API
module "pipeline_to_opnsense" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description      = "Allow Pipeline to OPNsense API"
  sequence         = 100
  interfaces       = [local.pipeline_interface]
  protocol         = "TCP"
  source_net       = local.pipeline_net
  destination_net  = "10.10.40.1"
  destination_port = "8443"
  log              = true
}

# Allow Pipeline DNS (UDP)
module "pipeline_dns_udp" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description      = "Allow Pipeline DNS to Services (UDP)"
  sequence         = 102
  interfaces       = [local.pipeline_interface]
  protocol         = "UDP"
  source_net       = local.pipeline_net
  destination_net  = "NET_SERVICES"
  destination_port = "53"
}

# Allow Pipeline SSH to all zones
module "pipeline_ssh_services" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description      = "Allow Pipeline SSH to Services"
  sequence         = 111
  interfaces       = [local.pipeline_interface]
  protocol         = "TCP"
  source_net       = local.pipeline_net
  destination_net  = "NET_SERVICES"
  destination_port = "22"
}

# Allow Pipeline ICMP to Services
module "pipeline_icmp_services" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description     = "Allow Pipeline ICMP to Services"
  sequence        = 121
  interfaces      = [local.pipeline_interface]
  protocol        = "ICMP"
  source_net      = local.pipeline_net
  destination_net = "NET_SERVICES"
}

# Allow Pipeline to Internet
module "pipeline_to_internet" {
  source = "../../template-terraform/modules/opnsense-firewall-rule"

  description        = "Allow Pipeline to Internet"
  sequence           = 109
  interfaces         = [local.pipeline_interface]
  source_net         = local.pipeline_net
  destination_net    = "any"
  destination_invert = false
}
```

## Rule Processing

1. Rules are evaluated in `sequence` order (lowest first)
2. First matching rule with `quick = true` stops processing
3. If no rule matches, traffic is denied (default deny)
4. Use `action = "block"` for explicit deny rules
5. Use `log = true` for debugging and audit trails

## Prerequisites

1. OPNsense firewall configured with VLANs
2. Aliases created for network zones (`NET_*`)
3. API credentials with firewall rule permissions
4. Interfaces assigned and named in OPNsense UI
