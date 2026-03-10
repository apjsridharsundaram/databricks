# =============================================================================
# Variables - Workspace Permissions
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

variable "permission_assignments" {
  description = "List of permission assignments. Each entry targets one resource and includes an access control list."
  type = list(object({
    resource_key = string

    # Object identifiers - set exactly one per entry
    authorization       = optional(string, null)
    cluster_id          = optional(string, null)
    cluster_policy_id   = optional(string, null)
    directory_path      = optional(string, null)
    experiment_id       = optional(string, null)
    instance_pool_id    = optional(string, null)
    job_id              = optional(string, null)
    notebook_path       = optional(string, null)
    pipeline_id         = optional(string, null)
    registered_model_id = optional(string, null)
    repo_id             = optional(string, null)
    serving_endpoint_id = optional(string, null)
    sql_alert_id        = optional(string, null)
    sql_dashboard_id    = optional(string, null)
    sql_endpoint_id     = optional(string, null)
    sql_query_id        = optional(string, null)
    workspace_file_path = optional(string, null)

    # Access control list
    access_control_list = list(object({
      group_name             = optional(string, null)
      user_name              = optional(string, null)
      service_principal_name = optional(string, null)
      permission_level       = string
    }))
  }))
  default = []
}
