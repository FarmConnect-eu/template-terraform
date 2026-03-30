variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: recette or prod"
  type        = string
}

variable "region" {
  description = "Registry region (GRA, DE, BHS — PAR1 not available for registries)"
  type        = string
  default     = "GRA"
}

variable "registry_admin_email" {
  description = "Admin email for the registry user"
  type        = string
}

variable "registry_plan" {
  description = "Registry plan: SMALL, MEDIUM, LARGE"
  type        = string
  default     = "SMALL"
}
