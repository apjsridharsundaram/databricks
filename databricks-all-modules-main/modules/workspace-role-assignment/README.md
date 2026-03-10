# workspace-role-assignment

Assigns principals (groups, users, or service principals) to a Databricks workspace using `databricks_mws_permission_assignment`.

## Purpose

This module manages **workspace-level role assignment** -- it controls _who_ can access a workspace and at what role level (USER or ADMIN). This is the account-level control plane operation that grants a principal access to a specific workspace.

This was the **missing piece** in the existing module library. The existing `user_assignment` module in `srafromrepo/` only supported single-user ADMIN assignment. This module supports:

- Group-based assignment (preferred for enterprise RBAC)
- User-based assignment (use sparingly)
- Service principal-based assignment

## How it differs from entitlements and permissions

| Concept | Resource | Scope | What it controls |
|---------|----------|-------|-----------------|
| **Role Assignment** | `databricks_mws_permission_assignment` | Account-level | Who can access the workspace (USER/ADMIN) |
| **Entitlements** | `databricks_entitlements` | Workspace-level | What capabilities a principal has (SQL access, cluster create, etc.) |
| **Permissions** | `databricks_permissions` | Object-level | Who can do what on specific objects (notebooks, jobs, clusters, etc.) |

## Usage

```hcl
module "workspace_role_assignment" {
  source = "../../databricks-all-modules-main/modules/workspace-role-assignment"

  providers = {
    databricks = databricks.account
  }

  workspace_id = databricks_mws_workspaces.this.workspace_id

  # Preferred: group-based assignment
  group_role_assignments = [
    {
      group_name  = "workspace-admins"
      permissions = ["ADMIN"]
    },
    {
      group_name  = "data-engineers"
      permissions = ["USER"]
    },
    {
      group_name  = "data-analysts"
      permissions = ["USER"]
    },
    {
      group_name  = "data-scientists"
      permissions = ["USER"]
    },
  ]

  # Use sparingly: direct user assignment
  user_role_assignments = []

  # Service principal assignment
  sp_role_assignments = []
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| workspace_id | Databricks workspace ID | `string` | n/a | yes |
| group_role_assignments | Group-based role assignments | `list(object)` | `[]` | no |
| user_role_assignments | User-based role assignments | `list(object)` | `[]` | no |
| sp_role_assignments | Service principal role assignments | `list(object)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| group_assignment_ids | Map of group name to assignment resource ID |
| user_assignment_ids | Map of user name to assignment resource ID |
| sp_assignment_ids | Map of SP application_id to assignment resource ID |
