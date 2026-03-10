# =============================================================================
# Variables - Workspace Role Assignment
# =============================================================================

variable "databricks_account_url" {
  description = "Databricks account console URL"
  type        = string
  default     = ""
}

variable "databricks_account_id" {
  description = "Databricks account ID"
  type        = string
  default     = ""
}

variable "databricks_account_token" {
  description = "Access token for the Databricks account"
  type        = string
  default     = ""
  sensitive   = true
}

variable "workspace_id" {
  description = "Databricks workspace ID to assign principals to"
  type        = string
}

variable "group_role_assignments" {
  description = "Group-based workspace role assignments (preferred for RBAC)"
  type = list(object({
    group_name  = string
    permissions = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for a in var.group_role_assignments :
      alltrue([for p in a.permissions : contains(["USER", "ADMIN"], p)])
    ])
    error_message = "Permissions must be either USER or ADMIN."
  }
}

variable "user_role_assignments" {
  description = "User-based workspace role assignments"
  type = list(object({
    user_name   = string
    permissions = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for a in var.user_role_assignments :
      alltrue([for p in a.permissions : contains(["USER", "ADMIN"], p)])
    ])
    error_message = "Permissions must be either USER or ADMIN."
  }
}

variable "sp_role_assignments" {
  description = "Service principal workspace role assignments"
  type = list(object({
    application_id = string
    permissions    = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for a in var.sp_role_assignments :
      alltrue([for p in a.permissions : contains(["USER", "ADMIN"], p)])
    ])
    error_message = "Permissions must be either USER or ADMIN."
  }
}
