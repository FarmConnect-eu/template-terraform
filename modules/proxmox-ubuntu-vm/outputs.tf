output "vm_id" {
  description = "ID de la VM Ubuntu Proxmox"
  value       = module.vm.vm_id
}

output "vm_name" {
  description = "Nom de la VM Ubuntu"
  value       = module.vm.vm_name
}

output "ipv4_address" {
  description = "Adresse IPv4 de la VM Ubuntu (détectée par l'agent)"
  value       = module.vm.ipv4_address
}

output "ssh_host" {
  description = "Host SSH de la VM Ubuntu"
  value       = module.vm.ssh_host
}

output "ssh_port" {
  description = "Port SSH de la VM Ubuntu"
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
