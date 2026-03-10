# workspace-group-member

Assigns users or service principals to Databricks workspace groups.

## Purpose

This module manages **group membership only**. It assigns individual users or service principals as members of workspace groups created by the `workspace-group` module.

Enterprise best practice: assign users to groups, then manage entitlements and permissions at the group level rather than per-user.

## Origin

Refactored from the existing `group-member` module. Enhanced to support bulk membership assignment via a list of member objects, enabling declarative membership management across multiple groups.

## Usage

```hcl
module "workspace_group_members" {
  source = "../../databricks-all-modules-main/modules/workspace-group-member"

  members = [
    {
      group_id  = module.workspace_groups.group_ids["data-engineers"]
      member_id = databricks_user.engineer_1.id
    },
    {
      group_id  = module.workspace_groups.group_ids["data-engineers"]
      member_id = databricks_service_principal.etl_sp.id
    },
    {
      group_id  = module.workspace_groups.group_ids["workspace-admins"]
      member_id = databricks_user.admin_1.id
    },
  ]
}
```

## Inputs

| Name    | Description | Type | Default | Required |
|---------|-------------|------|---------|----------|
| members | List of group membership assignments | `list(object)` | `[]` | no |

## Outputs

| Name           | Description |
|----------------|-------------|
| membership_ids | Map of membership key to resource ID |
| memberships    | Full map of group membership resources |
