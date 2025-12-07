output "id" {
  description = "The UUID of the alias"
  value       = opnsense_firewall_alias.this.id
}

output "name" {
  description = "The name of the alias"
  value       = opnsense_firewall_alias.this.name
}

output "type" {
  description = "The type of the alias"
  value       = opnsense_firewall_alias.this.type
}

output "alias_summary" {
  description = "Summary of the alias configuration"
  value = {
    id          = opnsense_firewall_alias.this.id
    name        = opnsense_firewall_alias.this.name
    type        = opnsense_firewall_alias.this.type
    enabled     = opnsense_firewall_alias.this.enabled
    description = opnsense_firewall_alias.this.description
  }
}
