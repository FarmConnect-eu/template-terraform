locals {
  # Déterminer si on utilise cloud-init ISO ou les paramètres natifs
  use_cloudinit_iso    = var.cloud_init_iso_id != null
  use_cloudinit_native = !local.use_cloudinit_iso && var.ciuser != null
}

resource "proxmox_vm_qemu" "vm" {
  # Identification de la VM
  name        = var.vm_name
  target_node = var.target_node
  vmid        = var.vmid
  description = var.description
  tags        = var.tags
  pool        = var.pool != "" ? var.pool : null

  # Création : Clone ou ISO
  clone      = var.clone_template
  full_clone = var.clone_template != null ? var.full_clone : null

  # BIOS et Boot
  bios   = var.bios
  boot   = var.boot_order
  tablet = var.tablet

  # VGA Configuration
  vga {
    type = var.vga
  }

  # OS Type
  os_type = var.os_type
  qemu_os = var.qemu_os

  # CPU Configuration
  cpu {
    cores   = var.cpu_cores
    sockets = var.cpu_sockets
    type    = var.cpu_type
  }

  # Memory Configuration
  memory  = var.memory_mb
  balloon = var.balloon

  # SCSI Controller
  scsihw = var.scsihw

  # Main disk (scsi0, virtio0, or sata0 depending on disk_type)
  dynamic "disk" {
    for_each = var.clone_template != null || var.iso_file != null ? [1] : []
    content {
      type       = "disk"
      slot       = var.disk_type == "scsi" ? "scsi0" : var.disk_type == "virtio" ? "virtio0" : "sata0"
      storage    = var.disk_storage
      size       = var.disk_size
      format     = var.disk_format
      cache      = var.disk_cache
      discard    = var.disk_discard
      emulatessd = var.disk_type != "virtio" ? var.disk_ssd_emulation : false
      iothread   = var.disk_type == "scsi" ? var.disk_iothread : false
      backup     = true
      replicate  = false
    }
  }

  # ISO disk (ide0)
  dynamic "disk" {
    for_each = var.iso_file != null ? [1] : []
    content {
      type = "cdrom"
      slot = "ide0"
      iso  = var.iso_file
    }
  }

  # Cloud-init ISO disk (ide2)
  dynamic "disk" {
    for_each = local.use_cloudinit_iso ? [1] : []
    content {
      type = "cdrom"
      slot = "ide2"
      iso  = var.cloud_init_iso_id
    }
  }

  # Network Configuration
  network {
    id        = 0
    model     = var.network_model
    bridge    = var.network_bridge
    tag       = var.vlan_tag > 0 ? var.vlan_tag : -1
    firewall  = var.network_firewall
    rate      = var.network_rate_limit > 0 ? var.network_rate_limit : null
    link_down = false
  }

  # EFI Disk (automatic when using OVMF BIOS)
  dynamic "efidisk" {
    for_each = var.bios == "ovmf" ? [1] : []
    content {
      efitype = var.efidisk_efitype
      storage = var.efidisk_storage != null ? var.efidisk_storage : var.disk_storage
    }
  }

  # Cloud-init native configuration (when not using custom ISO)
  ciuser       = local.use_cloudinit_native ? var.ciuser : null
  cipassword   = local.use_cloudinit_native ? var.cipassword : null
  sshkeys      = local.use_cloudinit_native ? var.sshkeys : null
  ipconfig0    = local.use_cloudinit_native ? var.ipconfig0 : null
  nameserver   = local.use_cloudinit_native ? var.nameserver : null
  searchdomain = local.use_cloudinit_native ? var.searchdomain : null

  # VM Lifecycle
  start_at_node_boot = var.onboot
  vm_state         = var.vm_state
  agent            = var.agent
  agent_timeout    = var.agent_timeout
  automatic_reboot = false
  protection       = var.protection
  hotplug          = var.hotplug

  # Attendre que cloud-init soit prêt
  skip_ipv6 = true

  lifecycle {
    ignore_changes = [
      # Ignorer les changements sur le réseau si l'IP est gérée par cloud-init
      network,
    ]
  }
}
