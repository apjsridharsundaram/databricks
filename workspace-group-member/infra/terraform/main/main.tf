# =============================================================================
# Main - Workspace Group Member
# Assigns users and service principals to Databricks workspace groups.
# =============================================================================

module "workspace_group_members" {
  source = "../../../../databricks-all-modules-main/modules/workspace-group-member"

  providers = {
    databricks = databricks.workspace
  }

  members = local.all_members
}
