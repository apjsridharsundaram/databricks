# =============================================================================
# Locals - Workspace Group Member
# =============================================================================

locals {
  # Build membership list from resolved data sources and explicit assignments
  resolved_members = [
    for m in var.membership_assignments : {
      group_id  = data.databricks_group.target_groups[m.group_name].id
      member_id = data.databricks_user.target_users[m.user_name].id
    }
  ]

  # Combine resolved members with any direct ID-based assignments
  all_members = concat(local.resolved_members, var.direct_members)
}
