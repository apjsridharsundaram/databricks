# =============================================================================
# Variables - Workspace Group
# =============================================================================

variable "databricks_workspace_url" {
  description = "URL of the Databricks workspace"
  type        = string
  default     = ""
}

variable "databricks_workspace_token" {
  description = "Access token for the Databricks workspace"
  type        = string
  default     = ""
  sensitive   = true
}

variable "additional_groups" {
  description = "Additional groups to create beyond the defaults defined in locals.tf"
  type = list(object({
    display_name               = string
    allow_cluster_create       = optional(bool, false)
    allow_instance_pool_create = optional(bool, false)
    databricks_sql_access      = optional(bool, false)
    workspace_access           = optional(bool, true)
    external_id                = optional(string, null)
    force                      = optional(bool, false)
  }))
  default = []
}
