# =============================================================================
# Data Sources - Workspace Group Member
# =============================================================================

# Look up groups by display name to resolve group IDs
data "databricks_group" "target_groups" {
  provider = databricks.workspace

  for_each     = toset(var.group_names)
  display_name = each.value
}

# Look up users by username to resolve user IDs
data "databricks_user" "target_users" {
  provider = databricks.workspace

  for_each  = toset(var.user_names)
  user_name = each.value
}
