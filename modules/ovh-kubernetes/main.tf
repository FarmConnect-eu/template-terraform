# MKS Standard cluster (multi-AZ control plane)
resource "ovh_cloud_project_kube" "this" {
  service_name = var.ovh_project_id
  name         = "${var.env}-${var.service_prefix}-cluster"
  region       = var.region
  version      = var.kubernetes_version

  private_network_id = var.private_network_id
  private_network_configuration {
    default_vrack_gateway              = var.vrack_gateway
    private_network_routing_as_default = true
  }

  update_policy = "ALWAYS_UPDATE"
}

resource "ovh_cloud_project_kube_nodepool" "this" {
  for_each = var.node_pools

  service_name  = var.ovh_project_id
  kube_id       = ovh_cloud_project_kube.this.id
  name          = each.key
  flavor_name   = each.value.flavor_name
  desired_nodes = each.value.desired_nodes
  min_nodes     = each.value.min_nodes
  max_nodes     = each.value.max_nodes
  autoscale     = each.value.autoscale

  template {
    metadata {
      annotations = {}
      finalizers  = []
      labels      = merge({ pool = each.key }, each.value.labels)
    }
    spec {
      unschedulable = false
      taints        = []
    }
  }
}
