# workspace-entitlements

Manages Databricks workspace-level entitlements (capabilities) for groups, users, and service principals.

## Purpose

This module controls **workspace-level capabilities** such as:
- `workspace_access` - Can access the workspace UI
- `databricks_sql_access` - Can use Databricks SQL
- `allow_cluster_create` - Can create clusters
- `allow_instance_pool_create` - Can create instance pools

This is different from:
- **Role Assignment** (account-level: USER/ADMIN workspace access)
- **Permissions** (object-level: ACLs on notebooks, jobs, etc.)

## Directory Structure

```
workspace-entitlements/
├── README.md
├── infra/
│   └── terraform/
│       └── main/
│           ├── aws-SE-99d097-databricks/
│           │   └── us-east-1/
│           │       └── terraform-workspace-entitlements.auto.tfvars
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
        └── workspace-entitlements/
            ├── README.md
            ├── go.mod
            ├── go.sum
            ├── workspace_entitlements_test.go
            ├── test-reports/
            │   ├── junit.xml
            │   └── test-output.txt
            └── test.sh
```

## Usage

```hcl
module "workspace_entitlements" {
  source = "../../../databricks-all-modules-main/modules/workspace-entitlements"

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
  ]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| group_entitlements | Group-based entitlements | `list(object)` | no |
| user_entitlements | User-based entitlements | `list(object)` | no |
| sp_entitlements | Service principal entitlements | `list(object)` | no |

## Outputs

| Name | Description |
|------|-------------|
| group_entitlement_ids | Map of group entitlement IDs |
| user_entitlement_ids | Map of user entitlement IDs |
| sp_entitlement_ids | Map of SP entitlement IDs |
