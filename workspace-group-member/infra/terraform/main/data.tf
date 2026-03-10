# =============================================================================
# Data Sources - Workspace Group Member
# =============================================================================

# Look up groups by display name to resolve group IDs
data "databricks_group" "target_groups" {
  provider = databricks.workspace

  for_each     = toset(concat(var.group_names, [for m in var.membership_assignments : m.group_name]))
  display_name = each.value
}

# Look up users by username to resolve user IDs
data "databricks_user" "target_users" {
  provider = databricks.workspace

  for_each  = toset(concat(var.user_names, [for m in var.membership_assignments : m.user_name]))
  user_name = each.value
}
