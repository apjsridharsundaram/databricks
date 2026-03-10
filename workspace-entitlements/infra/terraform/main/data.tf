# =============================================================================
# Data Sources - Workspace Entitlements
# =============================================================================

# Look up groups by display name to resolve group IDs for entitlements
data "databricks_group" "target_groups" {
  provider = databricks.workspace

  for_each     = toset(concat(var.group_names_for_entitlements, [for e in var.named_group_entitlements : e.group_name]))
  display_name = each.value
}
