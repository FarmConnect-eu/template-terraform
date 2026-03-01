# NFS Export Module - Creates project-specific exports via SSH remote-exec
# This module allows projects to add their own NFS exports to the server

locals {
  export_file_path = "/etc/exports.d/${var.project_name}.exports"

  # Generate exports file content
  exports_content = join("\n", [
    "# /etc/exports.d/${var.project_name}.exports",
    "# Managed by Terraform for project: ${var.project_name}",
    "# Do not edit manually",
    "",
    join("\n\n", [
      for export in var.exports : join("\n", [
        "# Export: ${export.path}",
        join("\n", [
          for client in export.clients :
          "${export.path} ${client.network}(${client.options})"
        ])
      ])
    ]),
    ""
  ])

  # List of directories to create
  directories_to_create = var.create_directories ? [
    for export in var.exports : export.path
  ] : []
}

resource "null_resource" "nfs_export" {
  triggers = {
    exports_content = sha256(local.exports_content)
    project_name    = var.project_name
    nfs_server_host = var.nfs_server_host
  }

  connection {
    type        = "ssh"
    host        = var.nfs_server_host
    user        = var.ssh_user
    private_key = var.ssh_private_key
    timeout     = var.ssh_timeout
  }

  # Create directories if requested
  provisioner "remote-exec" {
    inline = concat(
      ["echo 'Creating NFS export directories...'"],
      [
        for dir in local.directories_to_create :
        "sudo mkdir -p ${dir} && sudo chown ${var.directory_owner}:${var.directory_group} ${dir} && sudo chmod ${var.directory_mode} ${dir}"
      ],
      ["echo 'Directories created successfully'"]
    )
  }

  # Create the exports file
  provisioner "remote-exec" {
    inline = [
      "echo 'Creating exports file: ${local.export_file_path}'",
      "sudo mkdir -p /etc/exports.d",
      "cat << 'EXPORTS_EOF' | sudo tee ${local.export_file_path}",
      local.exports_content,
      "EXPORTS_EOF",
      "sudo chmod 644 ${local.export_file_path}",
      "echo 'Reloading NFS exports...'",
      "sudo exportfs -ra",
      "echo 'NFS exports reloaded successfully'",
      "sudo exportfs -v | grep -E '^${var.exports[0].path}' || true"
    ]
  }

  # Cleanup on destroy
  provisioner "remote-exec" {
    when = destroy
    inline = [
      "echo 'Removing exports file: /etc/exports.d/${self.triggers.project_name}.exports'",
      "sudo rm -f /etc/exports.d/${self.triggers.project_name}.exports",
      "echo 'Reloading NFS exports...'",
      "sudo exportfs -ra",
      "echo 'NFS exports cleanup completed'"
    ]
  }
}
