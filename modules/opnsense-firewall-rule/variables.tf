variable "description" {
  description = "Rule description"
  type        = string
}

variable "enabled" {
  description = "Enable this rule"
  type        = bool
  default     = true
}

variable "sequence" {
  description = "Rule order (lower = higher priority)"
  type        = number
  default     = 100
}

variable "interfaces" {
  description = "Interfaces to apply the rule on"
  type        = list(string)
}

variable "interface_invert" {
  description = "Apply to all but selected interfaces"
  type        = bool
  default     = false
}

variable "action" {
  description = "Action: pass, block, reject"
  type        = string
  default     = "pass"

  validation {
    condition     = contains(["pass", "block", "reject"], var.action)
    error_message = "Action must be pass, block, or reject."
  }
}

variable "direction" {
  description = "Traffic direction: in, out"
  type        = string
  default     = "in"

  validation {
    condition     = contains(["in", "out"], var.direction)
    error_message = "Direction must be in or out."
  }
}

variable "protocol" {
  description = "Protocol: any, TCP, UDP, TCP/UDP, ICMP, etc."
  type        = string
  default     = "any"
}

variable "quick" {
  description = "Stop processing on match"
  type        = bool
  default     = true
}

variable "source_net" {
  description = "Source network/alias (e.g., any, 10.0.0.0/24, alias_name)"
  type        = string
  default     = null
}

variable "source_port" {
  description = "Source port(s)"
  type        = string
  default     = ""
}

variable "source_invert" {
  description = "Invert source match"
  type        = bool
  default     = false
}

variable "destination_net" {
  description = "Destination network/alias"
  type        = string
  default     = null
}

variable "destination_port" {
  description = "Destination port(s)"
  type        = string
  default     = ""
}

variable "destination_invert" {
  description = "Invert destination match"
  type        = bool
  default     = false
}

variable "log" {
  description = "Log matching packets"
  type        = bool
  default     = false
}
