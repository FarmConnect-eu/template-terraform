output "postgresql_endpoint" {
  description = "PostgreSQL cluster connection endpoints"
  value       = ovh_cloud_project_database.postgresql.endpoints
  sensitive   = true
}

output "mysql_wordpress_endpoint" {
  description = "MySQL WordPress connection endpoints"
  value       = ovh_cloud_project_database.mysql_wordpress.endpoints
  sensitive   = true
}

output "opensearch_endpoint" {
  description = "OpenSearch connection endpoints"
  value       = ovh_cloud_project_database.opensearch.endpoints
  sensitive   = true
}

output "postgresql_cluster_id" {
  description = "PostgreSQL cluster ID"
  value       = ovh_cloud_project_database.postgresql.id
}

output "mysql_cluster_id" {
  description = "MySQL cluster ID"
  value       = ovh_cloud_project_database.mysql_wordpress.id
}
