# workspace-entitlements

Manages workspace-level entitlements for groups, users, or service principals.

## Purpose

This module manages **workspace entitlements** -- the capabilities a principal has within a workspace. Entitlements are different from permissions (which control access to specific objects) and role assignments (which control workspace access at the account level).

Supported entitlements:

| Entitlement | Description |
|-------------|-------------|
| `workspace_access` | Can the principal access the workspace UI/API |
| `databricks_sql_access` | Can the principal use Databricks SQL |
| `allow_cluster_create` | Can the principal create clusters |
| `allow_instance_pool_create` | Can the principal create instance pools |

## Origin

This is a **new module** that cleanly separates entitlement management from the existing `group` module. The original `group` module embedded entitlement flags directly on the `databricks_group` resource. This module uses the dedicated `databricks_entitlements` resource for explicit, fine-grained control.

## Usage

```hcl
module "workspace_entitlements" {
  source = "../../databricks-all-modules-main/modules/workspace-entitlements"

  group_entitlements = [
    {
      group_id              = module.workspace_groups.group_ids["data-engineers"]
      workspace_access      = true
      databricks_sql_access = true
      allow_cluster_create  = true
    },
    {
      group_id              = module.workspace_groups.group_ids["data-analysts"]
      workspace_access      = true
      databricks_sql_access = true
      allow_cluster_create  = false
    },
    {
      group_id              = module.workspace_groups.group_ids["data-scientists"]
      workspace_access      = true
      databricks_sql_access = true
      allow_cluster_create  = true
    },
    {
      group_id                   = module.workspace_groups.group_ids["workspace-admins"]
      workspace_access           = true
      databricks_sql_access      = true
      allow_cluster_create       = true
      allow_instance_pool_create = true
    },
  ]
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| group_entitlements | Group-level entitlements | `list(object)` | `[]` | no |
| user_entitlements | User-level entitlements | `list(object)` | `[]` | no |
| sp_entitlements | Service principal entitlements | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| group_entitlement_ids | Map of group_id to entitlements resource ID |
| user_entitlement_ids | Map of user_id to entitlements resource ID |
| sp_entitlement_ids | Map of service_principal_id to entitlements resource ID |
