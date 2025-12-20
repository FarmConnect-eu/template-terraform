output "vm_id" {
  description = "ID de la VM Debian Proxmox"
  value       = module.vm.vm_id
}

output "vm_name" {
  description = "Nom de la VM Debian"
  value       = module.vm.vm_name
}

output "ipv4_address" {
  description = "Adresse IPv4 de la VM Debian (détectée par l'agent)"
  value       = module.vm.ipv4_address
}

output "ssh_host" {
  description = "Host SSH de la VM Debian"
  value       = module.vm.ssh_host
}

output "ssh_port" {
  description = "Port SSH de la VM Debian"
  value       = module.vm.ssh_port
}

output "ssh_connection" {
  description = "Commande SSH complète pour se connecter"
  value       = "ssh fc-admin@${module.vm.ssh_host}"
}

output "vm_state" {
  description = "État actuel de la VM"
  value       = module.vm.vm_state
}

output "vm_password" {
  description = "Password for cloud-init user (auto-generated or provided)"
  value       = local.effective_password
  sensitive   = true
}

output "vm_user" {
  description = "Cloud-init user name"
  value       = var.ciuser
}
