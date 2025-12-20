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

  # Cloud-init ISO mode (for complex operations like runcmd, packages)
  use_cloud_init_iso = var.create_cloud_init_iso
  use_external_iso   = var.cloud_init_iso_id != null

  # Password: use provided or generate
  effective_password = var.cipassword != null ? var.cipassword : random_password.vm_password.result

  # SSH keys as newline-separated string for native cloud-init
  sshkeys_string = length(var.ssh_keys) > 0 ? join("\n", var.ssh_keys) : null
}

# Auto-generate secure password for fc-admin user
resource "random_password" "vm_password" {
  length  = 16
  special = false # Avoid special chars for console compatibility
}

# Auto-create cloud-init ISO if enabled (legacy mode)
resource "proxmox_cloud_init_disk" "auto" {
  count = local.use_cloud_init_iso ? 1 : 0

  name     = "${var.vm_name}-cloud-init"
  pve_node = var.target_node
  storage  = var.disk_storage

  user_data = templatefile("${path.module}/templates/cloud-init-basic.yml", {
    hostname    = var.vm_name
    ssh_keys    = var.ssh_keys
    ci_user     = var.ciuser
    ci_password = local.effective_password
  })
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

  # Cloud-init ISO (for complex operations: runcmd, write_files, packages)
  cloud_init_iso_id = local.use_external_iso ? var.cloud_init_iso_id : (local.use_cloud_init_iso && length(proxmox_cloud_init_disk.auto) > 0 ? proxmox_cloud_init_disk.auto[0].id : null)

  # Native cloud-init params (always passed through for hybrid configuration)
  # These work alongside cloud-init ISO:
  # - Native: user, password, network (reliable, handled by Proxmox)
  # - ISO: runcmd, write_files, packages (complex operations)
  ciuser       = var.ciuser
  cipassword   = local.effective_password
  sshkeys      = local.sshkeys_string
  ipconfig0    = var.ipconfig0
  nameserver   = var.nameserver
  searchdomain = var.searchdomain

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
