resource "grafana_dashboard" "this" {
  config_json = var.config_json
  folder      = var.folder
  org_id      = var.org_id
  overwrite   = var.overwrite
  message     = var.message
}
