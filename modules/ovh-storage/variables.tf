variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: staging or prod"
  type        = string
}

variable "region" {
  description = "OVH S3 region (GRA umbrella region, not GRA9)"
  type        = string
  default     = "GRA"
}

variable "buckets" {
  description = "Map of S3 buckets to create. Key is the logical name, value is the bucket name."
  type        = map(string)
}
