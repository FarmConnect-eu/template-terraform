variable "ovh_project_id" {
  description = "OVH Public Cloud project ID"
  type        = string
}

variable "env" {
  description = "Environment: staging or prod"
  type        = string
}

variable "service_prefix" {
  description = "Service name prefix for resource naming (e.g. myproject)"
  type        = string
}

variable "region" {
  description = "OVH region for managed databases (GRA, not GRA9)"
  type        = string
  default     = "GRA"
}

variable "private_network_id" {
  description = "vRack private network ID (from ovh-networking module)"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID within the vRack (from ovh-networking module)"
  type        = string
}

variable "postgresql_version" {
  description = "PostgreSQL engine version"
  type        = string
  default     = "18"
}

variable "mysql_version" {
  description = "MySQL engine version"
  type        = string
  default     = "8"
}

variable "opensearch_version" {
  description = "OpenSearch engine version"
  type        = string
  default     = "2"
}

variable "db_plan" {
  description = "OVH Cloud Databases plan: essential (1 node) or business (HA multi-node)"
  type        = string
}

variable "db_flavor" {
  description = "Database node flavor (e.g. db1-4 for staging, db1-15 for prod)"
  type        = string
}

variable "opensearch_plan" {
  description = "OpenSearch plan"
  type        = string
  default     = "business"
}

variable "opensearch_flavor" {
  description = "OpenSearch node flavor"
  type        = string
  default     = "db1-15"
}

variable "allowed_ips" {
  description = "List of IP restrictions for database access"
  type = list(object({
    ip          = string
    description = string
  }))
  default = []
}
