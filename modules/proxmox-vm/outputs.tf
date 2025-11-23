output "vm_id" {
  description = "ID de la VM Proxmox"
  value       = proxmox_vm_qemu.vm.vmid
}

output "vm_name" {
  description = "Nom de la VM"
  value       = proxmox_vm_qemu.vm.name
}

output "ipv4_address" {
  description = "Adresse IPv4 de la VM (détectée par l'agent)"
  value       = proxmox_vm_qemu.vm.default_ipv4_address
}

output "ssh_host" {
  description = "Host SSH de la VM"
  value       = proxmox_vm_qemu.vm.ssh_host
}

output "ssh_port" {
  description = "Port SSH de la VM"
  value       = proxmox_vm_qemu.vm.ssh_port
}

output "vm_state" {
  description = "État actuel de la VM"
  value       = proxmox_vm_qemu.vm.vm_state
}
