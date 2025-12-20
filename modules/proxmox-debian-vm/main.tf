locals {
  # Template par défaut - Debian 13 (Trixie) generic cloud only
  default_templates = {
    "13" = "debian-13-genericcloud"
  }

  template_name = var.clone_template != null ? var.clone_template : local.default_templates[var.debian_version]

  # Tags : ajouter "debian" et la version
  all_tags = concat(
    ["debian", "debian-${var.debian_version}"],
    var.tags
  )
  tags_string = join(",", local.all_tags)
}

module "vm" {
  source = "../proxmox-vm"

  # Identification
  vm_name     = var.vm_name
  target_node = var.target_node
  vmid        = var.vmid
  description = var.description
  tags        = local.tags_string
  pool        = var.pool

  # Source : Template ou ISO
  clone_template = var.iso_file == null ? local.template_name : null
  iso_file       = var.iso_file
  full_clone     = var.full_clone

  # CPU Configuration (host type pour meilleures performances)
  cpu_cores   = var.cpu_cores
  cpu_sockets = var.cpu_sockets
  cpu_type    = "host"

  # Memory Configuration
  memory_mb = var.memory_mb
  balloon   = 0 # Désactivé pour de meilleures performances

  # Disk Configuration (optimisé pour Linux)
  disk_size          = var.disk_size
  disk_storage       = var.disk_storage
  disk_type          = "scsi"
  disk_format        = "raw"
  disk_cache         = "none"
  disk_discard       = true
  disk_ssd_emulation = true
  disk_iothread      = true
  scsihw             = "virtio-scsi-single"

  # Network Configuration (virtio pour meilleures performances)
  network_model    = "virtio"
  network_bridge   = var.network_bridge
  vlan_tag         = var.vlan_tag
  network_firewall = var.network_firewall

  # Cloud-Init Configuration
  os_type = "cloud-init"
  qemu_os = "l26"

  # Cloud-init ISO (handles EVERYTHING: user, password, network, packages, runcmd)
  cloud_init_iso_id = var.cloud_init_iso_id

  # BIOS/Boot Configuration (UEFI pour Debian moderne)
  bios       = "ovmf"
  boot_order = "order=scsi0"
  tablet     = true

  # VM Lifecycle
  onboot        = var.onboot
  vm_state      = var.vm_state
  agent         = var.iso_file == null ? 1 : 0 # Agent seulement si cloud-init
  agent_timeout = 90
  protection    = var.protection
  hotplug       = "network,disk,usb"
}
