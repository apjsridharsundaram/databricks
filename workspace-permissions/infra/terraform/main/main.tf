# =============================================================================
# Main - Workspace Permissions
# Manages object-level ACLs on workspace resources.
# =============================================================================

module "workspace_permissions" {
  source = "../../../../databricks-all-modules-main/modules/workspace-permissions"

  providers = {
    databricks = databricks.workspace
  }

  permission_assignments = local.permission_assignments
}
