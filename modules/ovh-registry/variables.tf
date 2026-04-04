variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: staging or prod"
  type        = string
}

variable "service_prefix" {
  description = "Service name prefix for resource naming (e.g. myproject)"
  type        = string
}

variable "region" {
  description = "Registry region (GRA, DE, BHS — PAR1 not available for registries)"
  type        = string
  default     = "GRA"
}

variable "registry_plan" {
  description = "Registry plan: SMALL, MEDIUM, LARGE"
  type        = string
  default     = "SMALL"
}
