# =============================================================================
# Variables for workspace-permissions module
# =============================================================================

variable "permission_assignments" {
  description = <<-EOT
    List of permission assignments for workspace objects/resources.
    Each entry defines permissions on a single object (identified by exactly
    one of the resource ID/path fields) with one or more access control entries.

    Object identifier attributes (set exactly one per assignment):
      - authorization       : Authorization type (e.g., "tokens", "passwords")
      - cluster_id          : Cluster ID
      - cluster_policy_id   : Cluster policy ID
      - directory_path      : Directory path
      - experiment_id       : MLflow experiment ID
      - instance_pool_id    : Instance pool ID
      - job_id              : Job ID
      - notebook_path       : Notebook path
      - pipeline_id         : DLT pipeline ID
      - registered_model_id : Registered model ID
      - repo_id             : Repo ID
      - serving_endpoint_id : Model serving endpoint ID
      - sql_alert_id        : SQL alert ID
      - sql_dashboard_id    : SQL dashboard ID
      - sql_endpoint_id     : SQL warehouse/endpoint ID
      - sql_query_id        : SQL query ID
      - workspace_file_path : Workspace file path

    Access control attributes:
      - resource_key           (required) Unique key for this permission assignment.
      - access_control_list    (required) List of ACL entries.
        - group_name             (optional) Group name.
        - user_name              (optional) User email/name.
        - service_principal_name (optional) Service principal name.
        - permission_level       (required) Permission level (e.g., CAN_MANAGE, CAN_RUN, CAN_READ, CAN_EDIT, CAN_USE, CAN_ATTACH_TO, CAN_RESTART, CAN_VIEW, IS_OWNER).
  EOT

  type = list(object({
    resource_key = string

    # Object identifiers (exactly one should be set)
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

  validation {
    condition     = alltrue([for p in var.permission_assignments : length(p.resource_key) > 0])
    error_message = "Each permission_assignment must have a non-empty resource_key."
  }

  validation {
    condition     = alltrue([for p in var.permission_assignments : length(p.access_control_list) > 0])
    error_message = "Each permission_assignment must have at least one access_control_list entry."
  }
}
