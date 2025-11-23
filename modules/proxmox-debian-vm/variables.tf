variable "vm_name" {
  description = "Nom de la VM Debian"
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
  default     = "Debian VM"
}

variable "debian_version" {
  description = "Version de Debian (13 Trixie generic cloud only)"
  type        = string
  default     = "13"
  validation {
    condition     = contains(["13"], var.debian_version)
    error_message = "Seule Debian 13 (Trixie) generic cloud est supportée"
  }
}

variable "clone_template" {
  description = "Nom du template Debian à cloner (null pour template par défaut basé sur debian_version)"
  type        = string
  default     = null
}

variable "iso_file" {
  description = "Chemin de l'ISO Debian pour création manuelle (ex: 'local:iso/debian-12.4.0-amd64-netinst.iso')"
  type        = string
  default     = null
}

variable "full_clone" {
  description = "Clone complet (true) ou lié (false)"
  type        = bool
  default     = true
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

# Memory Configuration
variable "memory_mb" {
  description = "RAM en MB"
  type        = number
  default     = 2048
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

# Network Configuration
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

# Cloud-Init Configuration
variable "ssh_keys" {
  description = "SSH public keys for fc-admin user (used when auto-creating cloud-init ISO)"
  type        = list(string)
  default     = []
}

variable "create_cloud_init_iso" {
  description = "Auto-create cloud-init ISO with basic configuration. Set to false when providing external cloud_init_iso_id."
  type        = bool
  default     = true
}

variable "cloud_init_iso_id" {
  description = "ID of external cloud-init ISO created with proxmox_cloud_init_disk. If provided, set create_cloud_init_iso=false."
  type        = string
  default     = null
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

variable "protection" {
  description = "Protéger contre la suppression"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags supplémentaires (debian sera ajouté automatiquement)"
  type        = list(string)
  default     = []
}

variable "pool" {
  description = "Resource pool Proxmox"
  type        = string
  default     = ""
}
