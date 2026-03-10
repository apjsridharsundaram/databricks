# =============================================================================
# Workspace Group Module
# Creates Databricks workspace groups for persona-based RBAC.
# Refactored from the existing "group" module to cleanly separate
# group creation from entitlements and permissions.
# =============================================================================

resource "databricks_group" "this" {
  for_each = { for g in var.groups : g.display_name => g }

  display_name               = each.value.display_name
  allow_cluster_create       = each.value.allow_cluster_create
  allow_instance_pool_create = each.value.allow_instance_pool_create
  databricks_sql_access      = each.value.databricks_sql_access
  workspace_access           = each.value.workspace_access
  external_id                = each.value.external_id
  force                      = each.value.force
}
