output "id" {
  description = "The UUID of the NAT rule"
  value       = opnsense_firewall_nat.this.id
}

output "nat_summary" {
  description = "Summary of the NAT rule configuration"
  value = {
    id          = opnsense_firewall_nat.this.id
    interface   = opnsense_firewall_nat.this.interface
    protocol    = opnsense_firewall_nat.this.protocol
    target_ip   = var.target_ip
    target_port = var.target_port
    enabled     = opnsense_firewall_nat.this.enabled
    description = opnsense_firewall_nat.this.description
  }
}
