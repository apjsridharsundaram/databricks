# =============================================================================
# Variables - Workspace Group Member
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

variable "group_names" {
  description = "List of group display names to look up for membership assignments"
  type        = list(string)
  default     = []
}

variable "user_names" {
  description = "List of user names to look up for membership assignments"
  type        = list(string)
  default     = []
}

variable "membership_assignments" {
  description = "Name-based membership assignments (resolved via data sources)"
  type = list(object({
    group_name = string
    user_name  = string
  }))
  default = []
}

variable "direct_members" {
  description = "Direct ID-based membership assignments (bypasses data source lookups)"
  type = list(object({
    group_id  = string
    member_id = string
  }))
  default = []
}
