variable "vm_name" {
  description = "Nom de la VM Ubuntu"
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
  default     = "Ubuntu VM"
}

variable "ubuntu_version" {
  description = "Version d'Ubuntu (24.04 generic cloud only)"
  type        = string
  default     = "24.04"
  validation {
    condition     = contains(["24.04"], var.ubuntu_version)
    error_message = "Seule Ubuntu 24.04 generic cloud est supportée"
  }
}

variable "clone_template" {
  description = "Nom du template Ubuntu à cloner (null pour template par défaut basé sur ubuntu_version)"
  type        = string
  default     = null
}

variable "iso_file" {
  description = "Chemin de l'ISO Ubuntu pour création manuelle (ex: 'local:iso/ubuntu-22.04.3-live-server-amd64.iso')"
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
variable "cloud_init_iso_id" {
  description = "Cloud-init ISO ID (from proxmox_cloud_init_disk). ISO handles EVERYTHING: user, password, network, packages, runcmd."
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
  description = "Tags supplémentaires (ubuntu sera ajouté automatiquement)"
  type        = list(string)
  default     = []
}

variable "pool" {
  description = "Resource pool Proxmox"
  type        = string
  default     = ""
}
