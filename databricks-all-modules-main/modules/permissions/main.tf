resource "databricks_permissions" "this" {
  authorization        = var.authorization
  cluster_id           = var.cluster_id
  cluster_policy_id    = var.cluster_policy_id
  directory_path       = var.directory_path
  experiment_id        = var.experiment_id
  instance_pool_id     = var.instance_pool_id
  job_id               = var.job_id
  notebook_path        = var.notebook_path
  pipeline_id          = var.pipeline_id
  registered_model_id  = var.registered_model_id
  repo_id              = var.repo_id
  serving_endpoint_id  = var.serving_endpoint_id
  sql_alert_id         = var.sql_alert_id
  sql_dashboard_id     = var.sql_dashboard_id
  sql_endpoint_id      = var.sql_endpoint_id
  sql_query_id         = var.sql_query_id
  workspace_file_path  = var.workspace_file_path

  dynamic "access_control" {
    for_each = var.access_control_list
    content {
      group_name             = access_control.value.group_name
      user_name              = access_control.value.user_name
      service_principal_name = access_control.value.service_principal_name
      permission_level       = access_control.value.permission_level
    }
  }
}




