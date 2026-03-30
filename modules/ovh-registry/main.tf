data "ovh_cloud_project_capabilities_containerregistry_filter" "plan" {
  service_name = var.ovh_project_id
  plan_name    = var.registry_plan
  region       = var.region
}

# Managed private registry (Harbor) — replaces AWS ECR
resource "ovh_cloud_project_containerregistry" "this" {
  service_name = var.ovh_project_id
  name         = "${var.env}-agrimaker-registry"
  region       = var.region
  plan_id      = data.ovh_cloud_project_capabilities_containerregistry_filter.plan.id
}

resource "ovh_cloud_project_containerregistry_user" "admin" {
  service_name = var.ovh_project_id
  registry_id  = ovh_cloud_project_containerregistry.this.id
  email        = var.registry_admin_email
  login        = "agrimaker-admin"
}
