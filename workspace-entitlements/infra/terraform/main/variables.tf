# =============================================================================
# Variables - Workspace Entitlements
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

variable "group_names_for_entitlements" {
  description = "List of group display names to look up for name-based entitlement assignments"
  type        = list(string)
  default     = []
}

variable "named_group_entitlements" {
  description = "Name-based group entitlement assignments (resolved via data sources)"
  type = list(object({
    group_name                 = string
    workspace_access           = optional(bool, true)
    databricks_sql_access      = optional(bool, false)
    allow_cluster_create       = optional(bool, false)
    allow_instance_pool_create = optional(bool, false)
  }))
  default = []
}

variable "direct_group_entitlements" {
  description = "Direct ID-based group entitlement assignments"
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
  description = "User-based entitlement assignments"
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
  description = "Service principal entitlement assignments"
  type = list(object({
    service_principal_id       = string
    workspace_access           = optional(bool, true)
    databricks_sql_access      = optional(bool, false)
    allow_cluster_create       = optional(bool, false)
    allow_instance_pool_create = optional(bool, false)
  }))
  default = []
}
