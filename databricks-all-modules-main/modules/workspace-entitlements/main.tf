# =============================================================================
# Workspace Entitlements Module
# Manages workspace-level entitlements for groups, users, or service principals
# using the databricks_entitlements resource.
#
# This is a NEW module that cleanly separates entitlement management from
# group creation. Entitlements control what capabilities a principal has
# within a workspace (e.g., SQL access, cluster creation).
# =============================================================================

# -----------------------------------------------------------------------------
# Group-based entitlements (preferred for enterprise RBAC)
# -----------------------------------------------------------------------------
resource "databricks_entitlements" "group" {
  for_each = { for e in var.group_entitlements : e.group_id => e }

  group_id                   = each.value.group_id
  workspace_access           = each.value.workspace_access
  databricks_sql_access      = each.value.databricks_sql_access
  allow_cluster_create       = each.value.allow_cluster_create
  allow_instance_pool_create = each.value.allow_instance_pool_create
}

# -----------------------------------------------------------------------------
# User-based entitlements (use sparingly; prefer group-based)
# -----------------------------------------------------------------------------
resource "databricks_entitlements" "user" {
  for_each = { for e in var.user_entitlements : e.user_id => e }

  user_id                    = each.value.user_id
  workspace_access           = each.value.workspace_access
  databricks_sql_access      = each.value.databricks_sql_access
  allow_cluster_create       = each.value.allow_cluster_create
  allow_instance_pool_create = each.value.allow_instance_pool_create
}

# -----------------------------------------------------------------------------
# Service-principal-based entitlements
# -----------------------------------------------------------------------------
resource "databricks_entitlements" "service_principal" {
  for_each = { for e in var.sp_entitlements : e.service_principal_id => e }

  service_principal_id       = each.value.service_principal_id
  workspace_access           = each.value.workspace_access
  databricks_sql_access      = each.value.databricks_sql_access
  allow_cluster_create       = each.value.allow_cluster_create
  allow_instance_pool_create = each.value.allow_instance_pool_create
}
