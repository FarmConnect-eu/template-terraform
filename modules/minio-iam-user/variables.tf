variable "name" {
  type        = string
  description = "Name of the IAM user"

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]+$", var.name))
    error_message = "User name must contain only alphanumeric characters and +=,.@_- symbols."
  }
}

variable "force_destroy" {
  type        = bool
  description = "Delete user even if it has non-Terraform-managed IAM access keys"
  default     = false
}

variable "disable_user" {
  type        = bool
  description = "Disable the user"
  default     = false
}

variable "secret" {
  type        = string
  description = "Secret key for the user. If not set, MinIO will generate one."
  default     = null
  sensitive   = true
}

variable "tags" {
  type        = map(string)
  description = "Tags to assign to the user"
  default     = {}
}

variable "policy_names" {
  type        = list(string)
  description = "List of policy names to attach to the user"
  default     = []
}
