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

variable "bucket_actions" {
  description = <<-EOT
    S3 actions granted to the per-bucket application user, scoped to that bucket.
    Default is a least-privilege read/write/list set WITHOUT delete — suitable for
    immutable / legally-retained data (e.g. invoices). Pass ["s3:*"] explicitly if a
    bucket genuinely needs full control (delete, bucket admin).
  EOT
  type        = list(string)
  default = [
    "s3:GetObject",
    "s3:PutObject",
    "s3:ListBucket",
  ]
}
