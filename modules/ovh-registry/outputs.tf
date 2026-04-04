output "registry_url" {
  description = "Registry URL (replaces AWS ECR endpoint)"
  value       = ovh_cloud_project_containerregistry.this.url
}
