# =============================================================================
# Locals - Workspace Entitlements
# =============================================================================

locals {
  # Build group entitlements from name-based assignments
  resolved_group_entitlements = [
    for e in var.named_group_entitlements : {
      group_id                   = data.databricks_group.target_groups[e.group_name].id
      workspace_access           = e.workspace_access
      databricks_sql_access      = e.databricks_sql_access
      allow_cluster_create       = e.allow_cluster_create
      allow_instance_pool_create = e.allow_instance_pool_create
    }
  ]

  # Combine resolved entitlements with any direct ID-based entitlements
  all_group_entitlements = concat(local.resolved_group_entitlements, var.direct_group_entitlements)
}
