# Private networks (vRack) - one per VLAN
resource "ovh_cloud_project_network_private" "this" {
  for_each = var.networks

  service_name = var.ovh_project_id
  name         = "${var.env}-${each.key}-network"
  regions      = [var.region]
  vlan_id      = each.value.vlan_id
}

resource "ovh_cloud_project_network_private_subnet" "this" {
  for_each = var.networks

  service_name = var.ovh_project_id
  network_id   = ovh_cloud_project_network_private.this[each.key].id
  region       = var.region
  start        = each.value.dhcp_start
  end          = each.value.dhcp_end
  network      = each.value.cidr
  dhcp         = true
  no_gateway   = false
}

# Gateway for outbound internet access (attached to the designated gateway network)
resource "ovh_cloud_project_gateway" "this" {
  count = var.gateway_network_key != "" ? 1 : 0

  service_name = var.ovh_project_id
  name         = "${var.env}-${var.service_prefix}-gateway"
  model        = var.gateway_model
  region       = var.region
  network_id   = ovh_cloud_project_network_private.this[var.gateway_network_key].regions_openstack_ids[var.region]
  subnet_id    = ovh_cloud_project_network_private_subnet.this[var.gateway_network_key].id
}
