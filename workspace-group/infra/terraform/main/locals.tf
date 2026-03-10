# =============================================================================
# Locals - Workspace Group
# =============================================================================

locals {
  # Default persona groups for enterprise Databricks workspace RBAC
  default_groups = [
    {
      display_name     = "workspace-admins"
      workspace_access = true
    },
    {
      display_name     = "data-engineers"
      workspace_access = true
    },
    {
      display_name     = "data-analysts"
      workspace_access = true
    },
    {
      display_name     = "data-scientists"
      workspace_access = true
    },
  ]

  # Merge defaults with any additional groups from tfvars
  groups = concat(local.default_groups, var.additional_groups)
}
