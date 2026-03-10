# =============================================================================
# Main - Workspace Role Assignment
# Assigns principals to a Databricks workspace using
# databricks_mws_permission_assignment (USER or ADMIN role).
# =============================================================================

module "workspace_role_assignments" {
  source = "../../../../databricks-all-modules-main/modules/workspace-role-assignment"

  providers = {
    databricks = databricks.account
  }

  workspace_id = var.workspace_id

  group_role_assignments = local.group_role_assignments
  user_role_assignments  = local.user_role_assignments
  sp_role_assignments    = local.sp_role_assignments
}
