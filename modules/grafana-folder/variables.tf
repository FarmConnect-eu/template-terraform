variable "title" {
  type        = string
  description = "The title of the folder"

  validation {
    condition     = length(var.title) >= 1 && length(var.title) <= 255
    error_message = "Title must be between 1 and 255 characters."
  }
}

variable "uid" {
  type        = string
  description = "Unique identifier for the folder. If not set, Grafana will generate one."
  default     = null

  validation {
    condition     = var.uid == null || can(regex("^[a-zA-Z0-9_-]+$", var.uid))
    error_message = "UID must contain only alphanumeric characters, underscores, and hyphens."
  }
}

variable "org_id" {
  type        = string
  description = "The Organization ID. If not set, the Org ID defined in the provider block will be used."
  default     = null
}

variable "parent_folder_uid" {
  type        = string
  description = "The UID of the parent folder for nested folders. Requires nestedFolders feature flag."
  default     = null
}

variable "prevent_destroy_if_not_empty" {
  type        = bool
  description = "Prevent deletion if folder contains dashboards or alert rules. Requires Grafana 10.2+."
  default     = false
}
