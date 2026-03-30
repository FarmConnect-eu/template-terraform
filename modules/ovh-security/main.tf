# KMS (Key Management Service) — replaces AWS KMS
resource "ovh_okms" "this" {
  ovh_subsidiary = "FR"
  display_name   = "${var.env}-agrimaker-kms"
  region         = var.kms_region
}

resource "ovh_okms_service_key" "main" {
  okms_id    = ovh_okms.this.id
  name       = "${var.env}-agrimaker-main-key"
  type       = "RSA"
  size       = 4096
  operations = ["sign", "verify"]
}

# Application secrets stored in OVH KMS
resource "ovh_okms_secret" "jwt_security_key" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/jwt-securitykey"
  version = {
    data = jsonencode({ value = var.jwt_security_key })
  }
}

resource "ovh_okms_secret" "messengeo_sms" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/messengeo-sms-secret"
  version = {
    data = jsonencode({ value = var.messengeo_sms_secret })
  }
}

resource "ovh_okms_secret" "messengeo_email" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/messengeo-email-secret"
  version = {
    data = jsonencode({ value = var.messengeo_email_secret })
  }
}

resource "ovh_okms_secret" "auth_private_key_pem" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/auth-privatekeypem"
  version = {
    data = jsonencode({ value = var.auth_private_key_pem })
  }
}

resource "ovh_okms_secret" "auth_legacy_jwt" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/auth-legacyjwtsignature"
  version = {
    data = jsonencode({ value = var.auth_legacy_jwt })
  }
}

resource "ovh_okms_secret" "cookie_encryption_key" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/cookie-encryptionkey"
  version = {
    data = jsonencode({ value = var.cookie_encryption_key })
  }
}

resource "ovh_okms_secret" "icownect_tokensalt" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/icownect-tokensalt"
  version = {
    data = jsonencode({ value = var.icownect_tokensalt })
  }
}

resource "ovh_okms_secret" "baqio_api_key" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/baqio-api-key"
  version = {
    data = jsonencode({ value = var.baqio_api_key })
  }
}

resource "ovh_okms_secret" "oauth_portal1_secret" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/oauth-portal1-clientsecret"
  version = {
    data = jsonencode({ value = var.oauth_portal1_secret })
  }
}

resource "ovh_okms_secret" "oauth_agrimaker_secret" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/oauth-agrimaker-clientsecret"
  version = {
    data = jsonencode({ value = var.oauth_agrimaker_secret })
  }
}

resource "ovh_okms_secret" "dataprotection_key" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/dataprotection-key"
  version = {
    data = jsonencode({ value = var.dataprotection_key })
  }
}

resource "ovh_okms_secret" "s3_access_key" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/s3-access-key"
  version = {
    data = jsonencode({ value = var.s3_access_key })
  }
}

resource "ovh_okms_secret" "s3_secret_key" {
  okms_id = ovh_okms.this.id
  path    = "${var.env}/phoenix/s3-secret-key"
  version = {
    data = jsonencode({ value = var.s3_secret_key })
  }
}
