# S3 Object Storage user
resource "ovh_cloud_project_user" "s3" {
  service_name = var.ovh_project_id
  description  = "S3 Object Storage operator - ${var.env}"
  role_names   = ["objectstore_operator"]
}

# S3-compatible Object Storage credentials
resource "ovh_cloud_project_user_s3_credential" "batches" {
  service_name = var.ovh_project_id
  user_id      = ovh_cloud_project_user.s3.id
}

# S3 buckets
resource "ovh_cloud_project_storage" "this" {
  for_each = var.buckets

  service_name = var.ovh_project_id
  region_name  = var.region
  name         = each.value
}
