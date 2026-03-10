# =============================================================================
# Variables for workspace-role-assignment module
# =============================================================================

variable "workspace_id" {
  description = "The Databricks workspace ID to assign principals to."
  type        = string

  validation {
    condition     = length(var.workspace_id) > 0
    error_message = "workspace_id must be a non-empty string."
  }
}

variable "group_role_assignments" {
  description = <<-EOT
    List of group-based workspace role assignments (preferred over user-based).
    Each entry assigns a group to the workspace with the specified permissions.

    Attributes:
      - group_name  (required) Display name of the Databricks group.
      - permissions (required) List of permissions: ["USER"] or ["ADMIN"].
  EOT

  type = list(object({
    group_name  = string
    permissions = list(string)
  }))

  default = []

  validation {
    condition = alltrue([
      for a in var.group_role_assignments :
      length(a.permissions) > 0 &&
      alltrue([for p in a.permissions : contains(["USER", "ADMIN"], p)])
    ])
    error_message = "Each permission must be either 'USER' or 'ADMIN'."
  }
}

variable "user_role_assignments" {
  description = <<-EOT
    List of user-based workspace role assignments.
    Use sparingly; prefer group_role_assignments for enterprise RBAC.

    Attributes:
      - user_name   (required) Email/username of the Databricks user.
      - permissions (required) List of permissions: ["USER"] or ["ADMIN"].
  EOT

  type = list(object({
    user_name   = string
    permissions = list(string)
  }))

  default = []

  validation {
    condition = alltrue([
      for a in var.user_role_assignments :
      length(a.permissions) > 0 &&
      alltrue([for p in a.permissions : contains(["USER", "ADMIN"], p)])
    ])
    error_message = "Each permission must be either 'USER' or 'ADMIN'."
  }
}

variable "sp_role_assignments" {
  description = <<-EOT
    List of service-principal-based workspace role assignments.

    Attributes:
      - application_id (required) Application ID of the service principal.
      - permissions    (required) List of permissions: ["USER"] or ["ADMIN"].
  EOT

  type = list(object({
    application_id = string
    permissions    = list(string)
  }))

  default = []

  validation {
    condition = alltrue([
      for a in var.sp_role_assignments :
      length(a.permissions) > 0 &&
      alltrue([for p in a.permissions : contains(["USER", "ADMIN"], p)])
    ])
    error_message = "Each permission must be either 'USER' or 'ADMIN'."
  }
}
