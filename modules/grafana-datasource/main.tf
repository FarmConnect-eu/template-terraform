locals {
  # Merge basic auth password into secure_json_data if basic auth is enabled
  secure_json_data = var.basic_auth_enabled && var.basic_auth_password != "" ? merge(
    var.secure_json_data,
    { basicAuthPassword = var.basic_auth_password }
  ) : var.secure_json_data
}

resource "grafana_data_source" "this" {
  name                = var.name
  type                = var.type
  url                 = var.url
  uid                 = var.uid
  org_id              = var.org_id
  is_default          = var.is_default
  access_mode         = var.access_mode
  basic_auth_enabled  = var.basic_auth_enabled
  basic_auth_username = var.basic_auth_username
  database_name       = var.database_name
  username            = var.username

  json_data_encoded = length(var.json_data) > 0 ? jsonencode(var.json_data) : null

  secure_json_data_encoded = length(local.secure_json_data) > 0 ? jsonencode(local.secure_json_data) : null
}
