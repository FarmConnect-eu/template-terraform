variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: recette or prod"
  type        = string
  validation {
    condition     = contains(["staging", "prod"], var.env)
    error_message = "env must be 'staging' or 'prod'."
  }
}

variable "region" {
  description = "OVH region (GRA9 for Gravelines)"
  type        = string
  default     = "GRA9"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "node_flavor" {
  description = "Node flavor (b3-8 recette, b3-16 prod)"
  type        = string
  default     = "b3-16"
}

variable "private_network_id" {
  description = "vRack private network ID (from ovh-networking module)"
  type        = string
}
