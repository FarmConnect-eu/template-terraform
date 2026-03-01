variable "project_name" {
  type        = string
  description = "Project name (used for export file naming: {project}.exports)"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "Project name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "nfs_server_host" {
  type        = string
  description = "NFS server hostname or IP address"
}

variable "ssh_user" {
  type        = string
  description = "SSH user for connecting to NFS server"
  default     = "fc-admin"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key content for authentication"
  sensitive   = true
}

variable "ssh_timeout" {
  type        = string
  description = "SSH connection timeout"
  default     = "30s"
}

variable "exports" {
  type = list(object({
    path = string
    clients = list(object({
      network = string
      options = string
    }))
  }))
  description = "List of NFS exports to create"

  validation {
    condition     = length(var.exports) > 0
    error_message = "At least one export must be defined."
  }
}

variable "create_directories" {
  type        = bool
  description = "Whether to create the export directories on the NFS server"
  default     = true
}

variable "directory_owner" {
  type        = string
  description = "Owner for created directories"
  default     = "nobody"
}

variable "directory_group" {
  type        = string
  description = "Group for created directories"
  default     = "nogroup"
}

variable "directory_mode" {
  type        = string
  description = "Permissions for created directories"
  default     = "0755"
}
