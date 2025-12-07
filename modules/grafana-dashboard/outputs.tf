output "id" {
  description = "The ID of the dashboard resource"
  value       = grafana_dashboard.this.id
}

output "uid" {
  description = "The UID of the dashboard"
  value       = grafana_dashboard.this.uid
}

output "dashboard_id" {
  description = "The numeric ID of the dashboard"
  value       = grafana_dashboard.this.dashboard_id
}

output "url" {
  description = "The full URL of the dashboard"
  value       = grafana_dashboard.this.url
}

output "version" {
  description = "The version of the dashboard"
  value       = grafana_dashboard.this.version
}

output "dashboard_summary" {
  description = "Summary of the dashboard configuration"
  value = {
    id           = grafana_dashboard.this.id
    uid          = grafana_dashboard.this.uid
    dashboard_id = grafana_dashboard.this.dashboard_id
    url          = grafana_dashboard.this.url
    version      = grafana_dashboard.this.version
    folder       = var.folder
  }
}
