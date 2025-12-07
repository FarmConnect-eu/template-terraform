output "id" {
  description = "The ID of the data source"
  value       = grafana_data_source.this.id
}

output "uid" {
  description = "The UID of the data source"
  value       = grafana_data_source.this.uid
}

output "name" {
  description = "The name of the data source"
  value       = grafana_data_source.this.name
}

output "type" {
  description = "The type of the data source"
  value       = grafana_data_source.this.type
}

output "datasource_summary" {
  description = "Summary of the data source configuration"
  value = {
    id         = grafana_data_source.this.id
    uid        = grafana_data_source.this.uid
    name       = grafana_data_source.this.name
    type       = grafana_data_source.this.type
    url        = grafana_data_source.this.url
    is_default = grafana_data_source.this.is_default
  }
}
