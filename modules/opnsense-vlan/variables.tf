variable "description" {
  description = "VLAN description"
  type        = string
}

variable "tag" {
  description = "802.1Q VLAN tag (1-4094)"
  type        = number

  validation {
    condition     = var.tag >= 1 && var.tag <= 4094
    error_message = "VLAN tag must be between 1 and 4094."
  }
}

variable "parent" {
  description = "Parent interface (e.g., vtnet1, igb1)"
  type        = string
}

variable "priority" {
  description = "802.1Q VLAN PCP (0-7)"
  type        = number
  default     = 0
}

variable "device" {
  description = "Custom VLAN device name (empty for auto-generated)"
  type        = string
  default     = ""
}
