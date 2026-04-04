variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: staging or prod"
  type        = string
  validation {
    condition     = contains(["staging", "prod"], var.env)
    error_message = "env must be 'staging' or 'prod'."
  }
}

variable "service_prefix" {
  description = "Service name prefix for resource naming (e.g. myproject)"
  type        = string
}

variable "region" {
  description = "OVH region (e.g. GRA9)"
  type        = string
  default     = "GRA9"
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.31"
}

variable "private_network_id" {
  description = "vRack private network ID (from ovh-networking module)"
  type        = string
}

variable "node_pools" {
  description = "Map of node pools to create. Key is the pool name."
  type = map(object({
    flavor_name   = string
    desired_nodes = number
    min_nodes     = number
    max_nodes     = number
    autoscale     = bool
    labels        = optional(map(string), {})
  }))
}
