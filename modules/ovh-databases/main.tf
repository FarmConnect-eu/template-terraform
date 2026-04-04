# PostgreSQL cluster (databases and users managed via scripts/provision_db_users.sh
# due to OVH API instability — 409/500 with state drift)
resource "ovh_cloud_project_database" "postgresql" {
  service_name = var.ovh_project_id
  description  = "${var.env}-${var.service_prefix}-postgresql"
  engine       = "postgresql"
  version      = var.postgresql_version
  plan         = var.db_plan
  flavor       = var.db_flavor

  nodes {
    region     = var.region
    subnet_id  = var.subnet_id
    network_id = var.private_network_id
  }

  # HA: second node in prod
  dynamic "nodes" {
    for_each = var.env == "prod" ? [1] : []
    content {
      region     = var.region
      subnet_id  = var.subnet_id
      network_id = var.private_network_id
    }
  }

  dynamic "ip_restrictions" {
    for_each = var.allowed_ips
    content {
      ip          = ip_restrictions.value.ip
      description = ip_restrictions.value.description
    }
  }
}

# MySQL cluster
resource "ovh_cloud_project_database" "mysql_wordpress" {
  service_name = var.ovh_project_id
  description  = "${var.env}-${var.service_prefix}-wordpress"
  engine       = "mysql"
  version      = var.mysql_version
  plan         = var.db_plan
  flavor       = var.db_flavor

  nodes {
    region     = var.region
    subnet_id  = var.subnet_id
    network_id = var.private_network_id
  }

  dynamic "ip_restrictions" {
    for_each = var.allowed_ips
    content {
      ip          = ip_restrictions.value.ip
      description = ip_restrictions.value.description
    }
  }
}

# OpenSearch cluster
resource "ovh_cloud_project_database" "opensearch" {
  service_name = var.ovh_project_id
  description  = "${var.env}-${var.service_prefix}-opensearch"
  engine       = "opensearch"
  version      = var.opensearch_version
  plan         = var.opensearch_plan
  flavor       = var.opensearch_flavor

  nodes {
    region     = var.region
    subnet_id  = var.subnet_id
    network_id = var.private_network_id
  }

  # HA: extra nodes in prod
  dynamic "nodes" {
    for_each = var.env == "prod" ? [1, 2] : []
    content {
      region     = var.region
      subnet_id  = var.subnet_id
      network_id = var.private_network_id
    }
  }

  dynamic "ip_restrictions" {
    for_each = var.allowed_ips
    content {
      ip          = ip_restrictions.value.ip
      description = ip_restrictions.value.description
    }
  }
}
