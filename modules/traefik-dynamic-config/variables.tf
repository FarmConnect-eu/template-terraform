variable "source_file" {
  type        = string
  description = "Local path to the Traefik dynamic config YAML to push"
}

variable "dest_filename" {
  type        = string
  description = "Filename on the NFS export (ex: agrimaker-staging.yml)"
}

variable "nfs_host_ip" {
  type        = string
  description = "NFS server IP hosting the Traefik dynamic directory"
}

variable "nfs_export_path" {
  type        = string
  description = "Absolute path of the export on the NFS server (ex: /srv/nfs/traefik/dmz-shared)"
}

variable "traefik_host_ip" {
  type        = string
  description = "IP of the Traefik VM consuming this NFS share (will be restarted after push)"
}

variable "traefik_container_name" {
  type        = string
  description = "Docker container name to restart on the Traefik VM"
  default     = "traefik"
}

variable "ssh_user" {
  type        = string
  description = "SSH user for both the NFS server and the Traefik VM"
  default     = "am-admin"
}

variable "ssh_private_key" {
  type        = string
  description = "SSH private key content used to reach both hosts"
  sensitive   = true
}
