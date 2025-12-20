variable "interface" {
  type        = string
  description = "Interface for incoming packets (e.g., 'wan', 'lan')"
}

variable "protocol" {
  type        = string
  description = "IP protocol to match (TCP, UDP, TCP/UDP, ICMP, etc.)"

  validation {
    condition     = contains(["TCP", "UDP", "TCP/UDP", "ICMP", "ESP", "AH", "GRE", "IPV6", "IGMP", "any"], var.protocol)
    error_message = "Protocol must be one of: TCP, UDP, TCP/UDP, ICMP, ESP, AH, GRE, IPV6, IGMP, any."
  }
}

variable "target_ip" {
  type        = string
  description = "Target IP address or alias. For interface IP, use '<int>ip' (e.g., 'wanip', 'lanip')."
}

variable "target_port" {
  type        = string
  description = "Target port number or service name. For ranges use dash (e.g., '80-443')."
  default     = null
}

variable "source_net" {
  type        = string
  description = "Source IP, CIDR, or alias. For interface net use '<int>' (e.g., 'lan'). Default: any"
  default     = "any"
}

variable "source_port" {
  type        = string
  description = "Source port number, range, or well-known name. Empty or null for any."
  default     = null
}

variable "source_invert" {
  type        = bool
  description = "Invert source match"
  default     = false
}

variable "destination_net" {
  type        = string
  description = "Destination IP, CIDR, or alias. Default: any"
  default     = "any"
}

variable "destination_port" {
  type        = string
  description = "Destination port number or service name"
  default     = null
}

variable "destination_invert" {
  type        = bool
  description = "Invert destination match"
  default     = false
}

variable "enabled" {
  type        = bool
  description = "Enable this NAT rule"
  default     = true
}

variable "disable_nat" {
  type        = bool
  description = "Disable NAT for matching traffic (stop processing)"
  default     = false
}

variable "log" {
  type        = bool
  description = "Log packets matching this rule"
  default     = false
}

variable "ip_protocol" {
  type        = string
  description = "Internet Protocol version: inet (IPv4) or inet6 (IPv6)"
  default     = "inet"

  validation {
    condition     = contains(["inet", "inet6"], var.ip_protocol)
    error_message = "IP protocol must be 'inet' or 'inet6'."
  }
}

variable "sequence" {
  type        = number
  description = "Order of this NAT rule"
  default     = 1
}

variable "description" {
  type        = string
  description = "Description for reference (max 255 chars, alphanumeric and spaces)"
  default     = ""

  validation {
    condition     = length(var.description) <= 255
    error_message = "Description must be 255 characters or less."
  }
}
