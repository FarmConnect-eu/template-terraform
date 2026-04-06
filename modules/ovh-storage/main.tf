# ─── Admin user (full access, for migration scripts and admin tasks) ─────────

resource "ovh_cloud_project_user" "admin" {
  service_name = var.ovh_project_id
  description  = "S3 admin operator - ${var.env}"
  role_names   = ["objectstore_operator"]
}

resource "ovh_cloud_project_user_s3_credential" "admin" {
  service_name = var.ovh_project_id
  user_id      = ovh_cloud_project_user.admin.id
}

resource "ovh_cloud_project_user_s3_policy" "admin" {
  service_name = var.ovh_project_id
  user_id      = ovh_cloud_project_user.admin.id
  policy = jsonencode({
    Statement = [{
      Sid      = "AllowFullS3Access"
      Effect   = "Allow"
      Action   = ["s3:*"]
      Resource = ["arn:aws:s3:::*", "arn:aws:s3:::*/*"]
    }]
  })
}

# ─── Per-bucket users (scoped access, for applications) ─────────────────────

resource "ovh_cloud_project_user" "per_bucket" {
  for_each     = var.buckets
  service_name = var.ovh_project_id
  description  = "S3 bucket operator - ${each.value} - ${var.env}"
  role_names   = ["objectstore_operator"]
}

resource "ovh_cloud_project_user_s3_credential" "per_bucket" {
  for_each     = var.buckets
  service_name = var.ovh_project_id
  user_id      = ovh_cloud_project_user.per_bucket[each.key].id
}

resource "ovh_cloud_project_user_s3_policy" "per_bucket" {
  for_each     = var.buckets
  service_name = var.ovh_project_id
  user_id      = ovh_cloud_project_user.per_bucket[each.key].id
  policy = jsonencode({
    Statement = [{
      Sid      = "AllowBucketAccess"
      Effect   = "Allow"
      Action   = ["s3:*"]
      Resource = [
        "arn:aws:s3:::${each.value}",
        "arn:aws:s3:::${each.value}/*"
      ]
    }]
  })
}

# ─── Buckets ────────────────────────────────────────────────────────────────

resource "ovh_cloud_project_storage" "this" {
  for_each = var.buckets

  service_name = var.ovh_project_id
  region_name  = var.region
  name         = each.value
}
