output "export_file_path" {
  description = "Path to the created exports file on the NFS server"
  value       = local.export_file_path
}

output "project_name" {
  description = "Project name used for the export"
  value       = var.project_name
}

output "directories_created" {
  description = "List of directories created on the NFS server"
  value       = local.directories_to_create
}

output "exports_content" {
  description = "Content of the exports file"
  value       = local.exports_content
}
