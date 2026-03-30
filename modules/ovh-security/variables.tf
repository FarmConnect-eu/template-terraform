variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: recette or prod"
  type        = string
}

variable "kms_region" {
  description = "KMS region (eu-west-par for Paris)"
  type        = string
  default     = "eu-west-par"
}

variable "jwt_security_key" {
  type      = string
  sensitive = true
}

variable "messengeo_sms_secret" {
  type      = string
  sensitive = true
}

variable "messengeo_email_secret" {
  type      = string
  sensitive = true
}

variable "auth_private_key_pem" {
  type      = string
  sensitive = true
}

variable "auth_legacy_jwt" {
  type      = string
  sensitive = true
}

variable "cookie_encryption_key" {
  type      = string
  sensitive = true
}

variable "icownect_tokensalt" {
  type      = string
  sensitive = true
}

variable "baqio_api_key" {
  type      = string
  sensitive = true
}

variable "oauth_portal1_secret" {
  type      = string
  sensitive = true
}

variable "oauth_agrimaker_secret" {
  type      = string
  sensitive = true
}

variable "dataprotection_key" {
  type      = string
  sensitive = true
}

variable "s3_access_key" {
  description = "S3 access key (from ovh-storage module)"
  type        = string
  sensitive   = true
}

variable "s3_secret_key" {
  description = "S3 secret key (from ovh-storage module)"
  type        = string
  sensitive   = true
}
