# MKS Standard cluster (multi-AZ control plane)
resource "ovh_cloud_project_kube" "this" {
  service_name = var.ovh_project_id
  name         = "${var.env}-agrimaker-cluster"
  region       = var.region
  version      = var.kubernetes_version

  private_network_id = var.private_network_id
  private_network_configuration {
    default_vrack_gateway              = ""
    private_network_routing_as_default = false
  }

  update_policy = "ALWAYS_UPDATE"
}

# Node pool recette (single AZ)
resource "ovh_cloud_project_kube_nodepool" "recette" {
  count         = var.env == "recette" ? 1 : 0
  service_name  = var.ovh_project_id
  kube_id       = ovh_cloud_project_kube.this.id
  name          = "recette-pool"
  flavor_name   = "b3-16"
  desired_nodes = 1
  min_nodes     = 1
  max_nodes     = 2
  autoscale     = false

  template {
    metadata {
      annotations = {}
      finalizers  = []
      labels = {
        env  = "recette"
        pool = "recette-pool"
      }
    }
    spec {
      unschedulable = false
      taints        = []
    }
  }
}

# Node pool prod — Zone A
resource "ovh_cloud_project_kube_nodepool" "prod_zone_a" {
  count         = var.env == "prod" ? 1 : 0
  service_name  = var.ovh_project_id
  kube_id       = ovh_cloud_project_kube.this.id
  name          = "prod-pool-zone-a"
  flavor_name   = var.node_flavor
  desired_nodes = 2
  min_nodes     = 2
  max_nodes     = 4
  autoscale     = true

  template {
    metadata {
      annotations = {}
      finalizers  = []
      labels = {
        env  = "prod"
        zone = "a"
        pool = "prod-pool-zone-a"
      }
    }
    spec {
      unschedulable = false
      taints        = []
    }
  }
}

# Node pool prod — Zone B
resource "ovh_cloud_project_kube_nodepool" "prod_zone_b" {
  count         = var.env == "prod" ? 1 : 0
  service_name  = var.ovh_project_id
  kube_id       = ovh_cloud_project_kube.this.id
  name          = "prod-pool-zone-b"
  flavor_name   = var.node_flavor
  desired_nodes = 2
  min_nodes     = 2
  max_nodes     = 4
  autoscale     = true

  template {
    metadata {
      annotations = {}
      finalizers  = []
      labels = {
        env  = "prod"
        zone = "b"
        pool = "prod-pool-zone-b"
      }
    }
    spec {
      unschedulable = false
      taints        = []
    }
  }
}
