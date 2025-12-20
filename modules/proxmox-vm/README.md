# proxmox-vm

Core Terraform module for Proxmox VM provisioning. This is the base module used by wrapper modules like `proxmox-debian-vm` and `proxmox-ubuntu-vm`.

## Overview

Creates and manages QEMU virtual machines on Proxmox VE with support for:
- Template cloning or ISO-based installation
- Cloud-init configuration via ISO
- UEFI (OVMF) or legacy BIOS boot
- VirtIO optimized disk and network
- QEMU guest agent integration

## Usage

### Basic Clone from Template

```hcl
module "vm" {
  source = "../../template-terraform/modules/proxmox-vm"

  vm_name      = "svc-app-1"
  target_node  = "pve-node-1"
  disk_storage = "local-lvm"

  clone_template = "debian-13-genericcloud"
}
```

### With Cloud-Init ISO

```hcl
resource "proxmox_cloud_init_disk" "app" {
  name     = "svc-app-1-cloud-init"
  pve_node = "pve-node-1"
  storage  = "local-lvm"

  user_data = templatefile("cloud-init.yml", {
    hostname = "svc-app-1"
    ssh_keys = ["ssh-ed25519 AAAA..."]
  })
}

module "vm" {
  source = "../../template-terraform/modules/proxmox-vm"

  vm_name           = "svc-app-1"
  target_node       = "pve-node-1"
  disk_storage      = "local-lvm"
  clone_template    = "debian-13-genericcloud"
  cloud_init_iso_id = proxmox_cloud_init_disk.app.id
}
```

### With VLAN Tagging

```hcl
module "vm" {
  source = "../../template-terraform/modules/proxmox-vm"

  vm_name        = "svc-postgres-1"
  target_node    = "pve-node-1"
  disk_storage   = "local-lvm"
  clone_template = "debian-13-genericcloud"

  network_bridge = "vmbr0"
  vlan_tag       = 20  # Services VLAN
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| proxmox | >= 3.0.1, < 4.0.0 |

## Inputs

### Required

| Name | Description | Type |
|------|-------------|------|
| `vm_name` | VM name | `string` |
| `target_node` | Proxmox node name | `string` |
| `disk_storage` | Storage pool for disk | `string` |

### VM Creation (choose one)

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `clone_template` | Template name to clone | `string` | `null` |
| `iso_file` | ISO path (e.g., `local:iso/debian.iso`) | `string` | `null` |

### Optional - Identity

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `vmid` | VM ID (auto if null) | `number` | `null` |
| `description` | VM description | `string` | `""` |
| `tags` | Comma-separated tags | `string` | `""` |
| `pool` | Proxmox resource pool | `string` | `""` |

### Optional - CPU

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `cpu_cores` | CPU cores | `number` | `2` |
| `cpu_sockets` | CPU sockets | `number` | `1` |
| `cpu_type` | CPU type (`host` recommended) | `string` | `"host"` |

### Optional - Memory

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `memory_mb` | RAM in MB | `number` | `2048` |
| `balloon` | Minimum RAM for ballooning (0=disabled) | `number` | `0` |

### Optional - Disk

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `disk_size` | Disk size (e.g., `32G`) | `string` | `"32G"` |
| `disk_type` | `scsi`, `virtio`, `sata`, `ide` | `string` | `"scsi"` |
| `disk_format` | `raw`, `qcow2`, `vmdk` | `string` | `"raw"` |
| `disk_cache` | Cache mode | `string` | `"none"` |
| `disk_discard` | Enable TRIM/discard | `bool` | `true` |
| `disk_ssd_emulation` | Emulate SSD | `bool` | `true` |
| `disk_iothread` | Enable iothreads | `bool` | `true` |
| `scsihw` | SCSI controller | `string` | `"virtio-scsi-single"` |

### Optional - Network

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `network_model` | NIC model (`virtio` recommended) | `string` | `"virtio"` |
| `network_bridge` | Proxmox bridge | `string` | `"vmbr0"` |
| `vlan_tag` | VLAN tag (0=disabled) | `number` | `0` |
| `network_firewall` | Enable Proxmox firewall | `bool` | `false` |
| `network_rate_limit` | Bandwidth limit in Mbps | `number` | `0` |

### Optional - Cloud-Init

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `cloud_init_iso_id` | Cloud-init ISO ID from `proxmox_cloud_init_disk` | `string` | `null` |
| `os_type` | OS type | `string` | `"cloud-init"` |
| `qemu_os` | QEMU OS type | `string` | `"l26"` |

### Optional - BIOS/Boot

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `bios` | `ovmf` (UEFI) or `seabios` | `string` | `"ovmf"` |
| `boot_order` | Boot order | `string` | `"order=scsi0"` |
| `vga` | VGA type | `string` | `"std"` |
| `efidisk_storage` | EFI disk storage (defaults to `disk_storage`) | `string` | `null` |
| `efidisk_efitype` | EFI disk type (`2m` or `4m`) | `string` | `"4m"` |

### Optional - Lifecycle

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `onboot` | Start on node boot | `bool` | `true` |
| `vm_state` | `running` or `stopped` | `string` | `"running"` |
| `agent` | QEMU agent (1=enabled) | `number` | `1` |
| `agent_timeout` | Agent timeout in seconds | `number` | `90` |
| `protection` | Protect from deletion | `bool` | `false` |
| `hotplug` | Hotplug features | `string` | `"network,disk,usb"` |

## Outputs

| Name | Description |
|------|-------------|
| `vm_id` | Proxmox VM ID |
| `vm_name` | VM name |
| `ipv4_address` | IPv4 address (from guest agent) |
| `ssh_host` | SSH host |
| `ssh_port` | SSH port |
| `vm_state` | Current VM state |

## Architecture Notes

### Module Hierarchy

```
proxmox-vm (this module)
├── proxmox-debian-vm (wrapper with Debian defaults)
└── proxmox-ubuntu-vm (wrapper with Ubuntu defaults)
```

Use wrapper modules for simplified deployment with OS-specific defaults and automatic cloud-init ISO creation.

### Cloud-Init Pattern

This module requires a pre-created cloud-init ISO via `proxmox_cloud_init_disk`. Wrapper modules handle this automatically.

```hcl
# Direct usage requires manual cloud-init ISO creation
resource "proxmox_cloud_init_disk" "example" { ... }

module "vm" {
  source            = "../proxmox-vm"
  cloud_init_iso_id = proxmox_cloud_init_disk.example.id
  ...
}
```

### Recommended Settings for Linux

| Setting | Value | Reason |
|---------|-------|--------|
| `cpu_type` | `"host"` | Best performance |
| `disk_type` | `"scsi"` | VirtIO SCSI support |
| `scsihw` | `"virtio-scsi-single"` | Optimal I/O |
| `network_model` | `"virtio"` | Best network performance |
| `bios` | `"ovmf"` | UEFI for modern distros |
| `disk_discard` | `true` | SSD TRIM support |
| `disk_iothread` | `true` | Better disk I/O |
