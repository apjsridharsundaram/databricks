# =============================================================================
# Workspace Group Module
# Creates Databricks workspace groups for persona-based RBAC.
# Refactored from the existing "group" module to cleanly separate
# group creation from entitlements and permissions.
# =============================================================================

resource "databricks_group" "this" {
  for_each = { for g in var.groups : g.display_name => g }

  display_name               = each.value.display_name
  allow_cluster_create       = lookup(each.value, "allow_cluster_create", false)
  allow_instance_pool_create = lookup(each.value, "allow_instance_pool_create", false)
  databricks_sql_access      = lookup(each.value, "databricks_sql_access", false)
  workspace_access           = lookup(each.value, "workspace_access", true)
  external_id                = lookup(each.value, "external_id", null)
  force                      = lookup(each.value, "force", false)
}
