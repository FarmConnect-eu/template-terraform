resource "minio_iam_user" "this" {
  name          = var.name
  force_destroy = var.force_destroy
  disable_user  = var.disable_user
  secret        = var.secret
  tags          = var.tags
}

resource "minio_iam_user_policy_attachment" "this" {
  for_each = toset(var.policy_names)

  user_name   = minio_iam_user.this.name
  policy_name = each.value
}
