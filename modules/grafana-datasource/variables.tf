variable "name" {
  type        = string
  description = "A unique name for the data source"

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "Name must be between 1 and 255 characters."
  }
}

variable "type" {
  type        = string
  description = "The data source type (prometheus, loki, postgres, influxdb, etc.)"

  validation {
    condition     = contains(["prometheus", "loki", "postgres", "influxdb", "elasticsearch", "mysql", "graphite"], var.type)
    error_message = "Type must be one of: prometheus, loki, postgres, influxdb, elasticsearch, mysql, graphite."
  }
}

variable "url" {
  type        = string
  description = "The URL for the data source"

  validation {
    condition     = can(regex("^https?://", var.url))
    error_message = "URL must start with http:// or https://."
  }
}

variable "uid" {
  type        = string
  description = "Unique identifier. If not set, Grafana will generate one."
  default     = null
}

variable "org_id" {
  type        = string
  description = "The Organization ID. If not set, the Org ID defined in the provider block will be used."
  default     = null
}

variable "is_default" {
  type        = bool
  description = "Whether to set the data source as default"
  default     = false
}

variable "access_mode" {
  type        = string
  description = "The method by which Grafana will access the data source: proxy or direct"
  default     = "proxy"

  validation {
    condition     = contains(["proxy", "direct"], var.access_mode)
    error_message = "Access mode must be either 'proxy' or 'direct'."
  }
}

variable "basic_auth_enabled" {
  type        = bool
  description = "Whether to enable basic auth for the data source"
  default     = false
}

variable "basic_auth_username" {
  type        = string
  description = "Basic auth username"
  default     = ""
}

variable "basic_auth_password" {
  type        = string
  description = "Basic auth password (sensitive)"
  default     = ""
  sensitive   = true
}

variable "database_name" {
  type        = string
  description = "The name of the database (required for postgres, mysql, influxdb)"
  default     = ""
}

variable "username" {
  type        = string
  description = "The username to authenticate to the data source"
  default     = ""
}

variable "json_data" {
  type        = map(any)
  description = "JSON data configuration options for the data source"
  default     = {}
}

variable "secure_json_data" {
  type        = map(any)
  description = "Secure JSON data configuration (sensitive values like passwords)"
  default     = {}
  sensitive   = true
}
