# KMS (Key Management Service)
resource "ovh_okms" "this" {
  ovh_subsidiary = var.ovh_subsidiary
  display_name   = "${var.env}-${var.service_prefix}-kms"
  region         = var.kms_region
}

resource "ovh_okms_service_key" "main" {
  okms_id    = ovh_okms.this.id
  name       = "${var.env}-${var.service_prefix}-main-key"
  type       = var.key_type
  size       = var.key_size
  operations = ["sign", "verify"]
}

# Application secrets stored in KMS
resource "ovh_okms_secret" "this" {
  for_each = var.secrets

  okms_id = ovh_okms.this.id
  path    = "${var.env}/${var.secrets_prefix}/${each.key}"
  version = {
    data = jsonencode({ value = each.value })
  }
}
