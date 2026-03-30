output "kms_id" {
  description = "OVH KMS service ID"
  value       = ovh_okms.this.id
}

output "kms_key_id" {
  description = "Main signing/verification key ID"
  value       = ovh_okms_service_key.main.id
}
