data "ovh_cloud_project_capabilities_containerregistry_filter" "plan" {
  service_name = var.ovh_project_id
  plan_name    = var.registry_plan
  region       = var.region
}

# Managed private registry (Harbor) — replaces AWS ECR
resource "ovh_cloud_project_containerregistry" "this" {
  service_name = var.ovh_project_id
  name         = "${var.env}-${var.service_prefix}-registry"
  region       = var.region
  plan_id      = data.ovh_cloud_project_capabilities_containerregistry_filter.plan.id
}

# User creation removed — OVH API returns 500 on this endpoint.
# Create the admin user manually via OVH console:
#   Public Cloud → Containers & Orchestration → Managed Private Registry → Users
