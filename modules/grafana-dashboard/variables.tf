variable "config_json" {
  type        = string
  description = "The complete dashboard model JSON. Can be a JSON string or use jsonencode()."

  validation {
    condition     = can(jsondecode(var.config_json))
    error_message = "config_json must be valid JSON."
  }
}

variable "folder" {
  type        = string
  description = "The ID or UID of the folder to save the dashboard in"
  default     = null
}

variable "org_id" {
  type        = string
  description = "The Organization ID. If not set, the Org ID defined in the provider block will be used."
  default     = null
}

variable "overwrite" {
  type        = bool
  description = "Set to true to overwrite existing dashboard with same title or UID"
  default     = true
}

variable "message" {
  type        = string
  description = "Commit message for the version history"
  default     = null
}
