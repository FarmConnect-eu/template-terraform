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

output "s3_access_key" {
  description = "S3 access key ID"
  value       = ovh_cloud_project_user_s3_credential.batches.access_key_id
  sensitive   = true
}

output "s3_secret_key" {
  description = "S3 secret access key"
  value       = ovh_cloud_project_user_s3_credential.batches.secret_access_key
  sensitive   = true
}
