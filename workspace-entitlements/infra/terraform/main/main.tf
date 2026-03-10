# =============================================================================
# Main - Workspace Entitlements
# Manages workspace-level capabilities for groups, users, and SPs.
# =============================================================================

module "workspace_entitlements" {
  source = "../../../../databricks-all-modules-main/modules/workspace-entitlements"

  providers = {
    databricks = databricks.workspace
  }

  group_entitlements = local.all_group_entitlements
  user_entitlements  = var.user_entitlements
  sp_entitlements    = var.sp_entitlements
}
