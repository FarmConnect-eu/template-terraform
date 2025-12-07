variable "name" {
  type        = string
  description = "The name of the zone (e.g., 'farmconnect.local.' or 'farmconnect.local'). Trailing dot is optional."

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.?$", var.name))
    error_message = "Zone name must be a valid DNS zone name."
  }
}

variable "kind" {
  type        = string
  description = "The kind of the zone: Native, Master, or Slave"
  default     = "Native"

  validation {
    condition     = contains(["Native", "Master", "Slave"], var.kind)
    error_message = "Kind must be one of: Native, Master, Slave."
  }
}

variable "nameservers" {
  type        = list(string)
  description = "The zone nameservers (required for Native and Master zones)"
  default     = []

  validation {
    condition     = alltrue([for ns in var.nameservers : can(regex("^[a-z0-9.-]+\\.?$", ns))])
    error_message = "Each nameserver must be a valid DNS hostname."
  }
}

variable "masters" {
  type        = list(string)
  description = "List of IP addresses configured as masters (Slave zones only)"
  default     = []

  validation {
    condition     = alltrue([for ip in var.masters : can(regex("^[0-9.]+$", ip))])
    error_message = "Each master must be a valid IP address."
  }
}

variable "account" {
  type        = string
  description = "The account owning the zone"
  default     = "admin"
}

variable "soa_edit_api" {
  type        = string
  description = "SOA-EDIT-API setting. See PowerDNS documentation for valid values."
  default     = null
}
