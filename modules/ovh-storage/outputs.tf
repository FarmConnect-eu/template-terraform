output "buckets" {
  description = "Map of created buckets (key => bucket name)"
  value = {
    for key, bucket in ovh_cloud_project_storage.this : key => bucket.name
  }
}

output "s3_endpoint" {
  description = "S3-compatible endpoint"
  value       = "https://s3.${lower(var.region)}.perf.cloud.ovh.net"
}

# Admin credentials (full access to all buckets)
output "s3_access_key" {
  description = "Admin S3 access key ID (full access)"
  value       = ovh_cloud_project_user_s3_credential.admin.access_key_id
  sensitive   = true
}

output "s3_secret_key" {
  description = "Admin S3 secret access key (full access)"
  value       = ovh_cloud_project_user_s3_credential.admin.secret_access_key
  sensitive   = true
}

# Per-bucket credentials (scoped access for applications)
output "per_bucket_credentials" {
  description = "Per-bucket S3 credentials (key => {access_key, secret_key})"
  value = {
    for key, _ in var.buckets : key => {
      access_key = ovh_cloud_project_user_s3_credential.per_bucket[key].access_key_id
      secret_key = ovh_cloud_project_user_s3_credential.per_bucket[key].secret_access_key
    }
  }
  sensitive = true
}
