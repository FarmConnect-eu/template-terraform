output "registry_url" {
  description = "Registry URL (replaces AWS ECR endpoint)"
  value       = ovh_cloud_project_containerregistry.this.url
}

output "registry_user" {
  description = "Registry admin login"
  value       = ovh_cloud_project_containerregistry_user.admin.login
}

output "registry_password" {
  description = "Registry admin password"
  value       = ovh_cloud_project_containerregistry_user.admin.password
  sensitive   = true
}
