# =============================================================================
# Variables for workspace-entitlements module
# =============================================================================

variable "group_entitlements" {
  description = <<-EOT
    List of group-level entitlement configurations (preferred over user-level).

    Attributes:
      - group_id                   (required) ID of the Databricks group.
      - workspace_access           (optional) Grant workspace access. Default: true.
      - databricks_sql_access      (optional) Grant Databricks SQL access. Default: false.
      - allow_cluster_create       (optional) Allow cluster creation. Default: false.
      - allow_instance_pool_create (optional) Allow instance pool creation. Default: false.
  EOT

  type = list(object({
    group_id                   = string
    workspace_access           = optional(bool, true)
    databricks_sql_access      = optional(bool, false)
    allow_cluster_create       = optional(bool, false)
    allow_instance_pool_create = optional(bool, false)
  }))

  default = []
}

variable "user_entitlements" {
  description = <<-EOT
    List of user-level entitlement configurations.
    Use sparingly; prefer group_entitlements for enterprise RBAC.

    Attributes:
      - user_id                    (required) ID of the Databricks user.
      - workspace_access           (optional) Grant workspace access. Default: true.
      - databricks_sql_access      (optional) Grant Databricks SQL access. Default: false.
      - allow_cluster_create       (optional) Allow cluster creation. Default: false.
      - allow_instance_pool_create (optional) Allow instance pool creation. Default: false.
  EOT

  type = list(object({
    user_id                    = string
    workspace_access           = optional(bool, true)
    databricks_sql_access      = optional(bool, false)
    allow_cluster_create       = optional(bool, false)
    allow_instance_pool_create = optional(bool, false)
  }))

  default = []
}

variable "sp_entitlements" {
  description = <<-EOT
    List of service-principal-level entitlement configurations.

    Attributes:
      - service_principal_id       (required) ID of the Databricks service principal.
      - workspace_access           (optional) Grant workspace access. Default: true.
      - databricks_sql_access      (optional) Grant Databricks SQL access. Default: false.
      - allow_cluster_create       (optional) Allow cluster creation. Default: false.
      - allow_instance_pool_create (optional) Allow instance pool creation. Default: false.
  EOT

  type = list(object({
    service_principal_id       = string
    workspace_access           = optional(bool, true)
    databricks_sql_access      = optional(bool, false)
    allow_cluster_create       = optional(bool, false)
    allow_instance_pool_create = optional(bool, false)
  }))

  default = []
}
