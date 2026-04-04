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

variable "ovh_subsidiary" {
  description = "OVH subsidiary code (FR, DE, etc.)"
  type        = string
}

variable "kms_region" {
  description = "KMS region (e.g. eu-west-par)"
  type        = string
  default     = "eu-west-par"
}

variable "secrets_prefix" {
  description = "Path prefix for secrets in KMS (e.g. phoenix)"
  type        = string
}

variable "key_type" {
  description = "KMS service key type"
  type        = string
  default     = "RSA"
}

variable "key_size" {
  description = "KMS service key size in bits"
  type        = number
  default     = 4096
}

variable "secret_names" {
  description = "List of secret names to store in KMS (used for for_each, must not be sensitive)"
  type        = set(string)
}

variable "secret_values" {
  description = "Map of secret name to secret data (sensitive values)"
  type        = map(string)
  sensitive   = true
}
