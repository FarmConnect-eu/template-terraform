output "id" {
  description = "The ID of the IAM user"
  value       = minio_iam_user.this.id
}

output "name" {
  description = "The name of the IAM user"
  value       = minio_iam_user.this.name
}

output "status" {
  description = "The status of the IAM user"
  value       = minio_iam_user.this.status
}

output "secret" {
  description = "The secret key of the IAM user (sensitive)"
  value       = minio_iam_user.this.secret
  sensitive   = true
}

output "attached_policies" {
  description = "List of attached policy names"
  value       = var.policy_names
}

output "user_summary" {
  description = "Summary of the IAM user"
  value = {
    id       = minio_iam_user.this.id
    name     = minio_iam_user.this.name
    status   = minio_iam_user.this.status
    disabled = var.disable_user
    policies = var.policy_names
  }
}
