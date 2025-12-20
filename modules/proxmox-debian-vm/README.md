# proxmox-debian-vm

Terraform wrapper module for deploying Debian VMs on Proxmox with sensible defaults and automatic cloud-init ISO generation.

## Overview

This module wraps `proxmox-vm` with:
- Debian-specific optimizations (VirtIO, UEFI, host CPU)
- Automatic cloud-init ISO creation with `fc-admin` user
- Auto-generated secure password
- Automatic Debian version tagging

## Usage

### Minimal Configuration

```hcl
module "svc_nfs" {
  source = "../../template-terraform/modules/proxmox-debian-vm"

  vm_name      = "svc-nfs-1"
  target_node  = "pve-node-1"
  disk_storage = "local-lvm"
  ssh_keys     = ["ssh-ed25519 AAAA... user@host"]
}
```

### Custom Resources

```hcl
module "svc_postgres" {
  source = "../../template-terraform/modules/proxmox-debian-vm"

  vm_name      = "svc-postgres-1"
  target_node  = "pve-node-1"
  disk_storage = "local-lvm"

  cpu_cores  = 4
  memory_mb  = 8192
  disk_size  = "100G"

  vlan_tag = 20  # Services VLAN
  ssh_keys = var.ssh_keys
}
```

### With External Cloud-Init ISO

```hcl
resource "proxmox_cloud_init_disk" "custom" {
  name     = "svc-app-1-cloud-init"
  pve_node = "pve-node-1"
  storage  = "local-lvm"
  user_data = file("custom-cloud-init.yml")
}

module "svc_app" {
  source = "../../template-terraform/modules/proxmox-debian-vm"

  vm_name      = "svc-app-1"
  target_node  = "pve-node-1"
  disk_storage = "local-lvm"

  create_cloud_init_iso = false
  cloud_init_iso_id     = proxmox_cloud_init_disk.custom.id
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| proxmox | >= 3.0.1, < 4.0.0 |
| random | >= 3.0.0 |

## Inputs

### Required

| Name | Description | Type |
|------|-------------|------|
| `vm_name` | Debian VM name | `string` |
| `target_node` | Proxmox node name | `string` |
| `disk_storage` | Storage pool for disk | `string` |

### Optional - VM Identity

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `vmid` | VM ID (auto if null) | `number` | `null` |
| `description` | VM description | `string` | `"Debian VM"` |
| `tags` | Additional tags (debian added automatically) | `list(string)` | `[]` |
| `pool` | Proxmox resource pool | `string` | `""` |

### Optional - Debian Version

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `debian_version` | Debian version (`"13"` only) | `string` | `"13"` |
| `clone_template` | Custom template name (null for default) | `string` | `null` |
| `iso_file` | ISO path for manual install | `string` | `null` |
| `full_clone` | Full clone (true) or linked (false) | `bool` | `true` |

### Optional - Resources

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `cpu_cores` | CPU cores | `number` | `2` |
| `cpu_sockets` | CPU sockets | `number` | `1` |
| `memory_mb` | RAM in MB | `number` | `2048` |
| `disk_size` | Disk size (e.g., `32G`) | `string` | `"32G"` |

### Optional - Network

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `network_bridge` | Proxmox bridge | `string` | `"vmbr0"` |
| `vlan_tag` | VLAN tag (0=disabled) | `number` | `0` |
| `network_firewall` | Enable Proxmox firewall | `bool` | `false` |

### Optional - Cloud-Init

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `ssh_keys` | SSH public keys for `fc-admin` user | `list(string)` | `[]` |
| `create_cloud_init_iso` | Auto-create cloud-init ISO | `bool` | `true` |
| `cloud_init_iso_id` | External cloud-init ISO ID | `string` | `null` |

### Optional - Lifecycle

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `onboot` | Start on node boot | `bool` | `true` |
| `vm_state` | `running` or `stopped` | `string` | `"running"` |
| `protection` | Protect from deletion | `bool` | `false` |

## Outputs

| Name | Description | Sensitive |
|------|-------------|-----------|
| `vm_id` | Proxmox VM ID | No |
| `vm_name` | Debian VM name | No |
| `ipv4_address` | IPv4 address (from guest agent) | No |
| `ssh_host` | SSH host | No |
| `ssh_port` | SSH port | No |
| `ssh_connection` | Full SSH command | No |
| `vm_state` | Current VM state | No |
| `vm_user` | Default user (`fc-admin`) | No |
| `vm_password` | Auto-generated password | **Yes** |

## Default User

All VMs created with this module have a standardized user:

| Setting | Value |
|---------|-------|
| Username | `fc-admin` |
| Groups | `sudo` |
| Shell | `/bin/bash` |
| Sudo | `NOPASSWD:ALL` |
| SSH | Keys from `ssh_keys` variable |
| Password | Auto-generated (see `vm_password` output) |

## Cloud-Init Template

The auto-generated cloud-init includes:
- Hostname configuration
- `fc-admin` user with SSH keys and sudo
- Root filesystem auto-grow
- Europe/Paris timezone (fr_FR.UTF-8 locale)

To customize, set `create_cloud_init_iso = false` and provide `cloud_init_iso_id`.

## Supported Templates

| Version | Template Name | Notes |
|---------|---------------|-------|
| 13 | `debian-13-genericcloud` | Trixie (default) |

## Optimizations Applied

This wrapper applies Linux-optimized settings:

| Setting | Value | Reason |
|---------|-------|--------|
| CPU type | `host` | Best performance |
| Disk type | `scsi` | VirtIO SCSI |
| SCSI HW | `virtio-scsi-single` | Optimal I/O |
| Network | `virtio` | Best network |
| BIOS | `ovmf` | UEFI boot |
| Balloon | `0` | Disabled for stability |
| Disk cache | `none` | Direct I/O |
| Discard | `true` | SSD TRIM |
| IOthread | `true` | Better I/O |

## Example: Full Infrastructure VM

```hcl
module "svc_postgres_1" {
  source = "../../template-terraform/modules/proxmox-debian-vm"

  vm_name      = "svc-postgres-1"
  vmid         = 121
  target_node  = var.target_node
  disk_storage = "local-lvm"
  description  = "PostgreSQL primary database server"

  cpu_cores  = 4
  memory_mb  = 16384
  disk_size  = "200G"

  network_bridge = "vmbr0"
  vlan_tag       = 20  # Services VLAN (10.10.20.0/24)

  ssh_keys   = var.ssh_keys
  tags       = ["database", "production"]
  protection = true
  onboot     = true
}

output "postgres_ip" {
  value = module.svc_postgres_1.ipv4_address
}

output "postgres_ssh" {
  value = module.svc_postgres_1.ssh_connection
}
```
