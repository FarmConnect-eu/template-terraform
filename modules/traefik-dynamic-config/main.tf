# Traefik Dynamic Config module
#
# Pushes a dynamic config YAML to an NFS export consumed by a Traefik container,
# then restarts that container so the new config is picked up.
#
# Why the restart: Traefik's file provider relies on inotify, which on an NFS
# mount does not receive events for writes made by other NFS clients. Touching
# the file from the Traefik VM is also impossible here because the docker-compose
# setup mounts the NFS share via a named Docker volume (`driver: local,
# type: nfs`) in `:ro` mode — there is no host path to touch and the container
# cannot write. `docker restart` is therefore the only reliable reload trigger.

resource "null_resource" "push" {
  triggers = {
    config_hash            = filemd5(var.source_file)
    nfs_host_ip            = var.nfs_host_ip
    nfs_dest_path          = "${var.nfs_export_path}/${var.dest_filename}"
    traefik_host_ip        = var.traefik_host_ip
    traefik_container_name = var.traefik_container_name
    ssh_user               = var.ssh_user
    ssh_private_key        = var.ssh_private_key
  }

  # Step 1 — SCP the config to the NFS server
  provisioner "file" {
    connection {
      type        = "ssh"
      host        = self.triggers.nfs_host_ip
      user        = self.triggers.ssh_user
      private_key = self.triggers.ssh_private_key
    }
    source      = var.source_file
    destination = self.triggers.nfs_dest_path
  }

  # Step 2 — Restart Traefik so it reloads the freshly-written config
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.triggers.traefik_host_ip
      user        = self.triggers.ssh_user
      private_key = self.triggers.ssh_private_key
    }
    inline = [
      "sudo docker restart ${self.triggers.traefik_container_name}",
    ]
  }

  # Cleanup on destroy — remove the config from NFS (no restart: the operator
  # handles a global reload if needed when tearing down a service)
  provisioner "remote-exec" {
    when = destroy
    connection {
      type        = "ssh"
      host        = self.triggers.nfs_host_ip
      user        = self.triggers.ssh_user
      private_key = self.triggers.ssh_private_key
    }
    inline = [
      "sudo rm -f ${self.triggers.nfs_dest_path}",
    ]
  }
}
