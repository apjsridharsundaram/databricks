# =============================================================================
# Workspace Permissions Module
# Manages object/resource-level permissions within a Databricks workspace.
# Refactored from the existing "permissions" module with the same comprehensive
# resource coverage, preserving the dynamic access_control block pattern.
# =============================================================================

resource "databricks_permissions" "this" {
  for_each = { for p in var.permission_assignments : p.resource_key => p }

  # Object identifiers - exactly one must be set per assignment
  authorization       = each.value.authorization
  cluster_id          = each.value.cluster_id
  cluster_policy_id   = each.value.cluster_policy_id
  directory_path      = each.value.directory_path
  experiment_id       = each.value.experiment_id
  instance_pool_id    = each.value.instance_pool_id
  job_id              = each.value.job_id
  notebook_path       = each.value.notebook_path
  pipeline_id         = each.value.pipeline_id
  registered_model_id = each.value.registered_model_id
  repo_id             = each.value.repo_id
  serving_endpoint_id = each.value.serving_endpoint_id
  sql_alert_id        = each.value.sql_alert_id
  sql_dashboard_id    = each.value.sql_dashboard_id
  sql_endpoint_id     = each.value.sql_endpoint_id
  sql_query_id        = each.value.sql_query_id
  workspace_file_path = each.value.workspace_file_path

  dynamic "access_control" {
    for_each = each.value.access_control_list
    content {
      group_name             = access_control.value.group_name
      user_name              = access_control.value.user_name
      service_principal_name = access_control.value.service_principal_name
      permission_level       = access_control.value.permission_level
    }
  }
}
