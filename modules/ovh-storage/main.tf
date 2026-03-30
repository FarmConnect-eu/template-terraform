# S3-compatible Object Storage credentials
# Buckets are created manually via S3 API (ovh_cloud_project_storage creates
# Swift containers incompatible with S3 High Performance credentials).
# Active buckets (suffixed -ovh, on s3.gra.perf.cloud.ovh.net):
#   - agrimaker-billing-ovh
#   - agrimaker-services-ovh
#   - agrimaker-wordpress-backup-ovh
resource "ovh_cloud_project_user_s3_credential" "batches" {
  service_name = var.ovh_project_id
  user_id      = var.s3_user_id
}
