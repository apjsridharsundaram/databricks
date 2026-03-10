# workspace-group

Creates Databricks workspace-level groups for persona-based RBAC.

## Purpose

This module is responsible for **group creation only**. It creates groups that represent organizational personas such as:

- **Workspace Admin** - Full workspace administration
- **Data Engineer** - ETL pipeline development and management
- **Data Analyst** - SQL-based analytics and dashboarding
- **Data Scientist** - ML experimentation and model development

Entitlements, memberships, and permissions are managed by their respective sibling modules.

## Directory Structure

```
workspace-group/
├── README.md
├── infra/
│   └── terraform/
│       └── main/
│           ├── aws-SE-99d097-databricks/
│           │   └── us-east-1/
│           │       └── terraform-workspace-group.auto.tfvars
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
        └── workspace-group/
            ├── README.md
            ├── go.mod
            ├── go.sum
            ├── workspace_group_test.go
            ├── test-reports/
            │   ├── junit.xml
            │   └── test-output.txt
            └── test.sh
```

## Usage

```hcl
module "workspace_groups" {
  source = "../../../databricks-all-modules-main/modules/workspace-group"

  groups = [
    {
      display_name     = "data-engineers"
      workspace_access = true
    },
    {
      display_name     = "data-analysts"
      workspace_access = true
    },
    {
      display_name     = "workspace-admins"
      workspace_access = true
    },
  ]
}
```

## Inputs

| Name   | Description | Type | Required |
|--------|-------------|------|----------|
| groups | List of workspace groups to create | `list(object)` | yes |

## Outputs

| Name        | Description |
|-------------|-------------|
| group_ids   | Map of group display_name to group ID |
| group_names | List of created group display names |
| groups      | Full map of created group resources |
