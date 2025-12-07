output "id" {
  description = "The ID of the IAM policy"
  value       = minio_iam_policy.this.id
}

output "name" {
  description = "The name of the IAM policy"
  value       = minio_iam_policy.this.name
}

output "policy" {
  description = "The policy document"
  value       = minio_iam_policy.this.policy
}

output "policy_summary" {
  description = "Summary of the IAM policy"
  value = {
    id   = minio_iam_policy.this.id
    name = minio_iam_policy.this.name
  }
}
