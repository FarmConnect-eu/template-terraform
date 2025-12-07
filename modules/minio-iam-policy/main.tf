resource "minio_iam_policy" "this" {
  name        = var.name
  name_prefix = var.name_prefix
  policy      = var.policy
}
