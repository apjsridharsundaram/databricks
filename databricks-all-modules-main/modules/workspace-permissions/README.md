# workspace-permissions

Manages object/resource-level permissions within a Databricks workspace.

## Purpose

This module manages **fine-grained object permissions** -- who can do what on specific workspace resources such as notebooks, repos, directories, jobs, pipelines, clusters, cluster policies, SQL warehouses, and more.

## Origin

Refactored from the existing `permissions` module. Enhanced to support multiple permission assignments via a list of objects (each identified by a unique `resource_key`), enabling declarative permission management across many workspace objects.

## Supported Resource Types

| Resource | Identifier Field | Common Permission Levels |
|----------|-----------------|------------------------|
| Cluster | `cluster_id` | CAN_ATTACH_TO, CAN_RESTART, CAN_MANAGE |
| Cluster Policy | `cluster_policy_id` | CAN_USE |
| Directory | `directory_path` | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| Experiment | `experiment_id` | CAN_READ, CAN_EDIT, CAN_MANAGE |
| Instance Pool | `instance_pool_id` | CAN_ATTACH_TO, CAN_MANAGE |
| Job | `job_id` | CAN_VIEW, CAN_MANAGE_RUN, IS_OWNER, CAN_MANAGE |
| Notebook | `notebook_path` | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| DLT Pipeline | `pipeline_id` | CAN_VIEW, CAN_RUN, CAN_MANAGE, IS_OWNER |
| Registered Model | `registered_model_id` | CAN_READ, CAN_EDIT, CAN_MANAGE_STAGING_VERSIONS, CAN_MANAGE_PRODUCTION_VERSIONS, CAN_MANAGE |
| Repo | `repo_id` | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| Serving Endpoint | `serving_endpoint_id` | CAN_VIEW, CAN_QUERY, CAN_MANAGE |
| SQL Alert | `sql_alert_id` | CAN_VIEW, CAN_RUN, CAN_MANAGE |
| SQL Dashboard | `sql_dashboard_id` | CAN_VIEW, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| SQL Warehouse | `sql_endpoint_id` | CAN_USE, CAN_MANAGE, IS_OWNER |
| SQL Query | `sql_query_id` | CAN_VIEW, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| Workspace File | `workspace_file_path` | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| Tokens/Passwords | `authorization` | CAN_USE, CAN_MANAGE |

## Usage

```hcl
module "workspace_permissions" {
  source = "../../databricks-all-modules-main/modules/workspace-permissions"

  permission_assignments = [
    {
      resource_key      = "shared-notebooks"
      directory_path    = "/Shared"
      access_control_list = [
        {
          group_name       = "data-engineers"
          permission_level = "CAN_EDIT"
        },
        {
          group_name       = "data-analysts"
          permission_level = "CAN_READ"
        },
      ]
    },
    {
      resource_key      = "prod-cluster-policy"
      cluster_policy_id = databricks_cluster_policy.production.id
      access_control_list = [
        {
          group_name       = "data-engineers"
          permission_level = "CAN_USE"
        },
      ]
    },
    {
      resource_key    = "analytics-warehouse"
      sql_endpoint_id = databricks_sql_endpoint.analytics.id
      access_control_list = [
        {
          group_name       = "data-analysts"
          permission_level = "CAN_USE"
        },
        {
          group_name       = "workspace-admins"
          permission_level = "CAN_MANAGE"
        },
      ]
    },
    {
      resource_key  = "token-management"
      authorization = "tokens"
      access_control_list = [
        {
          group_name       = "workspace-admins"
          permission_level = "CAN_MANAGE"
        },
        {
          group_name       = "data-engineers"
          permission_level = "CAN_USE"
        },
      ]
    },
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| permission_assignments | List of permission assignments for workspace objects | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| permission_ids | Map of resource_key to permissions resource ID |
| permissions | Full map of permission resources |
