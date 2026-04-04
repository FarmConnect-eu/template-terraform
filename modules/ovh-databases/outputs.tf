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

# Private hosts extracted from endpoints for DNS registration
output "postgresql_host" {
  description = "PostgreSQL private host (IP or hostname from vRack endpoint)"
  value       = try(ovh_cloud_project_database.postgresql.endpoints[0].domain, "")
}

output "postgresql_port" {
  description = "PostgreSQL private port"
  value       = try(ovh_cloud_project_database.postgresql.endpoints[0].port, 0)
}

output "mysql_wordpress_host" {
  description = "MySQL WordPress private host (IP or hostname from vRack endpoint)"
  value       = try(ovh_cloud_project_database.mysql_wordpress.endpoints[0].domain, "")
}

output "mysql_wordpress_port" {
  description = "MySQL WordPress private port"
  value       = try(ovh_cloud_project_database.mysql_wordpress.endpoints[0].port, 0)
}

output "opensearch_host" {
  description = "OpenSearch private host (IP or hostname from vRack endpoint)"
  value       = try(ovh_cloud_project_database.opensearch.endpoints[0].domain, "")
}

output "opensearch_port" {
  description = "OpenSearch private port"
  value       = try(ovh_cloud_project_database.opensearch.endpoints[0].port, 0)
}
