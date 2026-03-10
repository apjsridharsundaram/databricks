# =============================================================================
# Main - Workspace Group
# Creates Databricks workspace groups for persona-based RBAC.
# =============================================================================

module "workspace_groups" {
  source = "../../../../databricks-all-modules-main/modules/workspace-group"

  providers = {
    databricks = databricks.workspace
  }

  groups = local.groups
}
