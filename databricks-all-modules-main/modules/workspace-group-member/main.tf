# =============================================================================
# Workspace Group Member Module
# Assigns users or service principals to Databricks workspace groups.
# Refactored from the existing "group-member" module to support bulk
# membership assignment via a list of members.
# =============================================================================

resource "databricks_group_member" "this" {
  for_each = { for m in var.members : "${m.group_id}-${m.member_id}" => m }

  group_id  = each.value.group_id
  member_id = each.value.member_id
}
