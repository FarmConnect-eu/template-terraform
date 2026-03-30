output "cluster_id" {
  description = "MKS cluster ID"
  value       = ovh_cloud_project_kube.this.id
}

output "cluster_name" {
  description = "MKS cluster name"
  value       = ovh_cloud_project_kube.this.name
}

output "kubeconfig" {
  description = "Kubeconfig for kubectl"
  value       = ovh_cloud_project_kube.this.kubeconfig
  sensitive   = true
}

output "api_url" {
  description = "Kubernetes API URL"
  value       = ovh_cloud_project_kube.this.url
}
