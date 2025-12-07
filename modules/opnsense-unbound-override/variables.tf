variable "hostname" {
  type        = string
  description = "Name of the host without domain. Use '*' for wildcard."

  validation {
    condition     = can(regex("^[a-zA-Z0-9*_-]+$", var.hostname))
    error_message = "Hostname must contain only alphanumeric characters, hyphens, underscores, or '*' for wildcard."
  }
}

variable "domain" {
  type        = string
  description = "Domain of the host (e.g., 'farmconnect.local')"

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.domain))
    error_message = "Domain must be a valid DNS domain name."
  }
}

variable "type" {
  type        = string
  description = "Type of DNS record: A, AAAA, or MX"
  default     = "A"

  validation {
    condition     = contains(["A", "AAAA", "MX"], var.type)
    error_message = "Type must be one of: A, AAAA, MX."
  }
}

variable "server" {
  type        = string
  description = "IP address for A or AAAA records"
  default     = null
}

variable "mx_host" {
  type        = string
  description = "MX host name (for MX records)"
  default     = null
}

variable "mx_priority" {
  type        = number
  description = "MX priority (for MX records)"
  default     = null
}

variable "enabled" {
  type        = bool
  description = "Enable this host override"
  default     = true
}

variable "description" {
  type        = string
  description = "Optional description for reference"
  default     = ""
}
