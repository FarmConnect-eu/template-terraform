variable "name" {
  type        = string
  description = "Alias name. Must start with a letter or underscore, be less than 32 chars, alphanumeric or underscores only."

  validation {
    condition     = can(regex("^[a-zA-Z_][a-zA-Z0-9_]{0,30}$", var.name))
    error_message = "Name must start with a letter or underscore, be less than 32 characters, and contain only alphanumeric characters or underscores."
  }
}

variable "type" {
  type        = string
  description = "The type of alias: host, network, port, url, urltable, geoip, networkgroup, mac, asn, dynipv6host, internal, external, authgroup"

  validation {
    condition = contains([
      "host", "network", "port", "url", "urltable", "geoip",
      "networkgroup", "mac", "asn", "dynipv6host", "internal", "external", "authgroup"
    ], var.type)
    error_message = "Type must be one of: host, network, port, url, urltable, geoip, networkgroup, mac, asn, dynipv6host, internal, external, authgroup."
  }
}

variable "content" {
  type        = list(string)
  description = "The content of the alias. Content format depends on type."
  default     = []
}

variable "description" {
  type        = string
  description = "Optional description for reference"
  default     = ""
}

variable "enabled" {
  type        = bool
  description = "Enable this firewall alias"
  default     = true
}

variable "stats" {
  type        = bool
  description = "Maintain counters for each table entry"
  default     = false
}

variable "categories" {
  type        = list(string)
  description = "List of category IDs to apply"
  default     = []
}

variable "ip_protocol" {
  type        = list(string)
  description = "IP protocol version (IPv4, IPv6). Only for asn, geoip, or external types."
  default     = ["IPv4"]

  validation {
    condition     = alltrue([for p in var.ip_protocol : contains(["IPv4", "IPv6"], p)])
    error_message = "IP protocol must be IPv4 or IPv6."
  }
}

variable "update_freq" {
  type        = number
  description = "Refresh frequency in days for urltable type"
  default     = -1
}

variable "interface" {
  type        = string
  description = "Interface for dynipv6host type"
  default     = ""
}
