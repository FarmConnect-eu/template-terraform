variable "vm_name" {
  description = "Nom de la VM"
  type        = string
}

variable "target_node" {
  description = "Nom du node Proxmox cible"
  type        = string
}

variable "vmid" {
  description = "ID de la VM (automatique si non spécifié)"
  type        = number
  default     = null
}

variable "description" {
  description = "Description de la VM"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags de la VM (séparés par des virgules)"
  type        = string
  default     = ""
}

variable "pool" {
  description = "Resource pool Proxmox"
  type        = string
  default     = ""
}

# Création de VM : Clone ou ISO
variable "clone_template" {
  description = "Nom du template à cloner (si création depuis template)"
  type        = string
  default     = null
}

variable "full_clone" {
  description = "Clone complet (true) ou lié (false)"
  type        = bool
  default     = true
}

variable "iso_file" {
  description = "Chemin de l'ISO pour création depuis ISO (format: 'storage:iso/filename.iso')"
  type        = string
  default     = null
}

# CPU Configuration
variable "cpu_cores" {
  description = "Nombre de cores CPU"
  type        = number
  default     = 2
}

variable "cpu_sockets" {
  description = "Nombre de sockets CPU"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "Type de CPU (host recommandé pour Linux)"
  type        = string
  default     = "host"
}

# Memory Configuration
variable "memory_mb" {
  description = "RAM en MB"
  type        = number
  default     = 2048
}

variable "balloon" {
  description = "RAM minimum pour ballooning (0 = désactivé)"
  type        = number
  default     = 0
}

# Disk Configuration
variable "disk_size" {
  description = "Taille du disque principal (ex: '32G')"
  type        = string
  default     = "32G"
}

variable "disk_storage" {
  description = "Storage pool pour le disque"
  type        = string
}

variable "disk_type" {
  description = "Type de disque (scsi, virtio, sata, ide)"
  type        = string
  default     = "scsi"
}

variable "disk_format" {
  description = "Format du disque (raw, qcow2, vmdk)"
  type        = string
  default     = "raw"
}

variable "disk_cache" {
  description = "Mode de cache du disque"
  type        = string
  default     = "none"
}

variable "disk_discard" {
  description = "Activer TRIM/discard pour SSD"
  type        = bool
  default     = true
}

variable "disk_ssd_emulation" {
  description = "Émuler un SSD"
  type        = bool
  default     = true
}

variable "disk_iothread" {
  description = "Utiliser les iothreads pour de meilleures performances"
  type        = bool
  default     = true
}

variable "scsihw" {
  description = "Contrôleur SCSI (virtio-scsi-single recommandé)"
  type        = string
  default     = "virtio-scsi-single"
}

# Network Configuration
variable "network_model" {
  description = "Modèle de carte réseau (virtio recommandé pour Linux)"
  type        = string
  default     = "virtio"
}

variable "network_bridge" {
  description = "Bridge réseau Proxmox"
  type        = string
  default     = "vmbr0"
}

variable "vlan_tag" {
  description = "Tag VLAN (0 = désactivé)"
  type        = number
  default     = 0
}

variable "network_firewall" {
  description = "Activer le firewall Proxmox sur l'interface"
  type        = bool
  default     = false
}

variable "network_rate_limit" {
  description = "Limite de bande passante en Mbps (0 = illimité)"
  type        = number
  default     = 0
}

# Cloud-Init Configuration
variable "os_type" {
  description = "Type d'OS (cloud-init pour les images cloud)"
  type        = string
  default     = "cloud-init"
}

variable "qemu_os" {
  description = "Type d'OS QEMU (l26 pour Linux 2.6+)"
  type        = string
  default     = "l26"
}

variable "cloud_init_iso_id" {
  description = "ID of cloud-init ISO created with proxmox_cloud_init_disk (e.g., 'local:iso/vm-cloud-init.iso'). This is the ONLY way to configure cloud-init. Use wrapper modules for automatic ISO creation from simple parameters."
  type        = string
  default     = null
}

# BIOS/Boot Configuration
variable "bios" {
  description = "Type de BIOS (ovmf pour UEFI, seabios pour BIOS legacy)"
  type        = string
  default     = "ovmf"
}

variable "boot_order" {
  description = "Ordre de boot (ex: 'order=scsi0;net0')"
  type        = string
  default     = "order=scsi0"
}

variable "tablet" {
  description = "Activer le tablet USB pour la souris"
  type        = bool
  default     = true
}

variable "efidisk_storage" {
  description = "Storage pool for EFI disk (automatically configured when bios = 'ovmf'). If null, uses disk_storage value."
  type        = string
  default     = null
}

variable "efidisk_efitype" {
  description = "EFI disk type: '2m' or '4m' (4m recommended for Secure Boot support)"
  type        = string
  default     = "4m"

  validation {
    condition     = var.efidisk_efitype == "2m" || var.efidisk_efitype == "4m"
    error_message = "efidisk_efitype must be '2m' or '4m'"
  }
}

variable "vga" {
  description = "VGA hardware type (std, cirrus, vmware, qxl, serial0, qxl2, qxl3, qxl4, none, virtio). Use 'std' for noVNC access."
  type        = string
  default     = "std"

  validation {
    condition     = contains(["std", "cirrus", "vmware", "qxl", "serial0", "qxl2", "qxl3", "qxl4", "none", "virtio"], var.vga)
    error_message = "vga must be one of: std, cirrus, vmware, qxl, serial0, qxl2, qxl3, qxl4, none, virtio"
  }
}

# VM Lifecycle
variable "onboot" {
  description = "Démarrer la VM au boot du node Proxmox"
  type        = bool
  default     = true
}

variable "vm_state" {
  description = "État désiré de la VM (running, stopped)"
  type        = string
  default     = "running"
}

variable "agent" {
  description = "Activer QEMU guest agent (1 = activé)"
  type        = number
  default     = 1
}

variable "agent_timeout" {
  description = "Timeout en secondes pour l'agent QEMU"
  type        = number
  default     = 90
}

variable "protection" {
  description = "Protéger contre la suppression"
  type        = bool
  default     = false
}

variable "hotplug" {
  description = "Fonctionnalités hotplug activées"
  type        = string
  default     = "network,disk,usb"
}

variable "keyboard" {
  description = "Keyboard layout for VNC console (fr, en-us, de, etc.)"
  type        = string
  default     = "fr"
}
