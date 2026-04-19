output "nfs_dest_path" {
  description = "Absolute path of the pushed config on the NFS server"
  value       = "${var.nfs_export_path}/${var.dest_filename}"
}

output "config_hash" {
  description = "MD5 hash of the pushed config (useful for downstream depends_on wiring)"
  value       = filemd5(var.source_file)
}

output "resource_id" {
  description = "ID of the null_resource driving the push — use for explicit depends_on"
  value       = null_resource.push.id
}
