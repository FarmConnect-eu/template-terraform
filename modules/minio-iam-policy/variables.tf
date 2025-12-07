variable "name" {
  type        = string
  description = "Name of the IAM policy. Conflicts with name_prefix."
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name))
    error_message = "Policy name must contain only alphanumeric characters and +=,.@_- symbols."
  }
}

variable "name_prefix" {
  type        = string
  description = "Prefix for auto-generated policy name. Conflicts with name."
  default     = null
}

variable "policy" {
  type        = string
  description = "Policy document as JSON string. Use jsonencode() or heredoc."

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "Policy must be valid JSON."
  }
}
