# =============================================================================
# Data Sources - Workspace Entitlements
# =============================================================================

# Look up groups by display name to resolve group IDs for entitlements
data "databricks_group" "target_groups" {
  provider = databricks.workspace

  for_each     = toset(var.group_names_for_entitlements)
  display_name = each.value
}
