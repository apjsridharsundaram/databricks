# =============================================================================
# Variables for workspace-group module
# =============================================================================

variable "groups" {
  description = <<-EOT
    List of workspace groups to create. Each group represents a persona
    (e.g., Data Engineer, Data Analyst, Data Scientist, Workspace Admin).

    Attributes:
      - display_name               (required) Display name for the group (1-256 chars).
      - allow_cluster_create       (optional) Allow cluster creation. Default: false.
      - allow_instance_pool_create (optional) Allow instance pool creation. Default: false.
      - databricks_sql_access      (optional) Allow SQL access. Default: false.
      - workspace_access           (optional) Allow workspace access. Default: true.
      - external_id                (optional) External ID for SCIM/IdP sync.
      - force                      (optional) Force create even if exists. Default: false.
  EOT

  type = list(object({
    display_name               = string
    allow_cluster_create       = optional(bool, false)
    allow_instance_pool_create = optional(bool, false)
    databricks_sql_access      = optional(bool, false)
    workspace_access           = optional(bool, true)
    external_id                = optional(string, null)
    force                      = optional(bool, false)
  }))

  validation {
    condition     = alltrue([for g in var.groups : length(g.display_name) > 0 && length(g.display_name) <= 256])
    error_message = "Each group display_name must be between 1 and 256 characters."
  }
}
