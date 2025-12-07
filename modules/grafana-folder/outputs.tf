output "id" {
  description = "The numeric ID of the folder"
  value       = grafana_folder.this.id
}

output "uid" {
  description = "The UID of the folder"
  value       = grafana_folder.this.uid
}

output "title" {
  description = "The title of the folder"
  value       = grafana_folder.this.title
}

output "url" {
  description = "The full URL of the folder"
  value       = grafana_folder.this.url
}

output "folder_summary" {
  description = "Summary of the folder configuration"
  value = {
    id    = grafana_folder.this.id
    uid   = grafana_folder.this.uid
    title = grafana_folder.this.title
    url   = grafana_folder.this.url
  }
}
