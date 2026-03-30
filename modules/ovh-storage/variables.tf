variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: recette or prod"
  type        = string
}

variable "region" {
  description = "OVH S3 region (GRA umbrella region, not GRA9)"
  type        = string
  default     = "GRA"
}

variable "s3_user_id" {
  description = "OVH user ID for S3 credentials"
  type        = string
}
