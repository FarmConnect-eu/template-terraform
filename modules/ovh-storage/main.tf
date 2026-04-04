# S3-compatible Object Storage credentials
resource "ovh_cloud_project_user_s3_credential" "batches" {
  service_name = var.ovh_project_id
  user_id      = var.s3_user_id
}

# S3 buckets
resource "ovh_cloud_project_storage" "this" {
  for_each = var.buckets

  service_name = var.ovh_project_id
  region_name  = var.region
  name         = each.value
}
