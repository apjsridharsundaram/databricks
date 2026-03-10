# workspace-role-assignment

Assigns principals (groups, users, service principals) to a Databricks workspace using `databricks_mws_permission_assignment`. This controls **workspace-level access** (USER or ADMIN role).

## Purpose

This is the **account-level** authorization module. It determines which principals can access a workspace and at what role level. This is different from:
- **Entitlements** (workspace capabilities like sql_access, cluster_create)
- **Permissions** (object-level ACLs on notebooks, jobs, etc.)

Group-based assignment is strongly preferred over direct user assignment for enterprise RBAC.

## Directory Structure

```
workspace-role-assignment/
├── README.md
├── infra/
│   └── terraform/
│       └── main/
│           ├── aws-SE-99d097-databricks/
│           │   └── us-east-1/
│           │       └── terraform-workspace-role-assignment.auto.tfvars
│           ├── data.tf
│           ├── locals.tf
│           ├── main.tf
│           ├── notes.txt
│           ├── outputs.tf
│           ├── providers.tf
│           ├── variables.tf
│           └── versions.tf
├── pipeline.yaml
└── test/
    └── terratest/
        ├── README.md
        └── workspace-role-assignment/
            ├── README.md
            ├── go.mod
            ├── go.sum
            ├── workspace_role_assignment_test.go
            ├── test-reports/
            │   ├── junit.xml
            │   └── test-output.txt
            └── test.sh
```

## Usage

```hcl
module "workspace_role_assignments" {
  source = "../../../databricks-all-modules-main/modules/workspace-role-assignment"

  providers = {
    databricks = databricks.account
  }

  workspace_id = var.databricks_workspace_id

  group_role_assignments = [
    {
      group_name  = "workspace-admins"
      permissions = ["ADMIN"]
    },
    {
      group_name  = "data-engineers"
      permissions = ["USER"]
    },
  ]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| workspace_id | Databricks workspace ID | `string` | yes |
| group_role_assignments | Group-based role assignments | `list(object)` | no |
| user_role_assignments | User-based role assignments | `list(object)` | no |
| sp_role_assignments | Service principal role assignments | `list(object)` | no |

## Outputs

| Name | Description |
|------|-------------|
| group_assignment_ids | Map of group role assignment IDs |
| user_assignment_ids | Map of user role assignment IDs |
| sp_assignment_ids | Map of SP role assignment IDs |
