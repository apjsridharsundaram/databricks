# workspace-group

Creates Databricks workspace-level groups for persona-based RBAC.

## Purpose

This module is responsible for **group creation only**. It creates groups that represent organizational personas such as:

- **Workspace Admin** - Full workspace administration
- **Data Engineer** - ETL pipeline development and management
- **Data Analyst** - SQL-based analytics and dashboarding
- **Data Scientist** - ML experimentation and model development

Entitlements, memberships, and permissions are managed by their respective sibling modules.

## Origin

Refactored from the existing `group` module. The entitlement flags (`allow_cluster_create`, `databricks_sql_access`, etc.) are retained on the group resource for backward compatibility, but enterprise deployments should prefer the `workspace-entitlements` module for fine-grained entitlement management.

## Usage

```hcl
module "workspace_groups" {
  source = "../../databricks-all-modules-main/modules/workspace-group"

  groups = [
    {
      display_name    = "data-engineers"
      workspace_access = true
    },
    {
      display_name    = "data-analysts"
      workspace_access = true
    },
    {
      display_name    = "data-scientists"
      workspace_access = true
    },
    {
      display_name    = "workspace-admins"
      workspace_access = true
    },
  ]
}
```

## Inputs

| Name   | Description | Type | Default | Required |
|--------|-------------|------|---------|----------|
| groups | List of workspace groups to create | `list(object)` | n/a | yes |

## Outputs

| Name        | Description |
|-------------|-------------|
| group_ids   | Map of group display_name to group ID |
| group_names | List of created group display names |
| groups      | Full map of created group resources |
