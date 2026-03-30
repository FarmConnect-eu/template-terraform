output "s3_bucket_billing" {
  description = "Billing bucket name"
  value       = "agrimaker-billing-ovh"
}

output "s3_bucket_services" {
  description = "Services bucket name"
  value       = "agrimaker-services-ovh"
}

output "s3_bucket_wordpress_backup" {
  description = "WordPress backup bucket name"
  value       = "agrimaker-wordpress-backup-ovh"
}

output "s3_endpoint" {
  description = "S3-compatible endpoint (replaces AWS S3 endpoint)"
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
