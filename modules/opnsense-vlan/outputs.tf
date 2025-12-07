output "id" {
  description = "UUID of the VLAN"
  value       = opnsense_interfaces_vlan.this.id
}

output "device" {
  description = "VLAN device name"
  value       = opnsense_interfaces_vlan.this.device
}

output "tag" {
  description = "VLAN tag"
  value       = opnsense_interfaces_vlan.this.tag
}
