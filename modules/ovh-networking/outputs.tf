output "networks" {
  description = "Map of created networks with their IDs"
  value = {
    for key, net in ovh_cloud_project_network_private.this : key => {
      private_network_id = net.regions_openstack_ids[var.region]
      subnet_id          = ovh_cloud_project_network_private_subnet.this[key].id
      vlan_id            = var.networks[key].vlan_id
      cidr               = var.networks[key].cidr
    }
  }
}

output "gateway_id" {
  description = "Gateway resource ID"
  value       = var.gateway_network_key != "" ? ovh_cloud_project_gateway.this[0].id : null
}

output "gateway_external_ip" {
  description = "Outbound IP address (communicate to partners)"
  value       = var.gateway_network_key != "" ? ovh_cloud_project_gateway.this[0].external_information[0].ips[0].ip : null
}
