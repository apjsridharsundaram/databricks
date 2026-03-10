# =============================================================================
# Variables for workspace-group-member module
# =============================================================================

variable "members" {
  description = <<-EOT
    List of group membership assignments. Each entry maps a member (user or
    service principal) to a group.

    Attributes:
      - group_id  (required) ID of the target Databricks group.
      - member_id (required) ID of the user or service principal to add.
  EOT

  type = list(object({
    group_id  = string
    member_id = string
  }))

  default = []

  validation {
    condition     = alltrue([for m in var.members : length(m.group_id) > 0 && length(m.member_id) > 0])
    error_message = "Both group_id and member_id must be non-empty strings."
  }
}
