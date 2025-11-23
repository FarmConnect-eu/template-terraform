variable "zone" {
  type        = string
  description = "DNS zone name (e.g., 'farmconnect.local' or 'farmconnect.local.'). Trailing dot is optional and will be added automatically if missing."

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.?$", var.zone))
    error_message = "Zone must be a valid DNS zone name."
  }
}

variable "name" {
  type        = string
  description = "Full DNS record name (FQDN) including zone (e.g., 'svc-postgres-1.farmconnect.local' or 'svc-postgres-1.farmconnect.local.'). Trailing dot is optional and will be added automatically if missing."

  validation {
    condition     = can(regex("^[a-z0-9.-]+\\.?$", var.name))
    error_message = "Name must be a valid DNS hostname."
  }
}

variable "type" {
  type        = string
  description = "DNS record type (A, CNAME, PTR, etc.)"
  default     = "A"

  validation {
    condition     = contains(["A", "CNAME", "PTR"], var.type)
    error_message = "Type must be one of: A, CNAME, PTR."
  }
}

variable "content" {
  type        = string
  description = "DNS record content (IP address for A record, hostname for CNAME, etc.)"
}

variable "ttl" {
  type        = number
  description = "Time to live in seconds"
  default     = 300

  validation {
    condition     = var.ttl >= 60 && var.ttl <= 86400
    error_message = "TTL must be between 60 and 86400 seconds."
  }
}

variable "create_ptr" {
  type        = bool
  description = "Create corresponding PTR (reverse DNS) record"
  default     = false
}

variable "reverse_zone" {
  type        = string
  description = "Reverse DNS zone for PTR records (e.g., '20.10.10.in-addr.arpa' or '20.10.10.in-addr.arpa.'). Trailing dot is optional and will be added automatically if missing."
  default     = ""

  validation {
    condition     = var.reverse_zone == "" || can(regex("^[0-9.-]+\\.in-addr\\.arpa\\.?$", var.reverse_zone))
    error_message = "Reverse zone must be empty or a valid reverse DNS zone (e.g., '20.10.10.in-addr.arpa')."
  }
}
