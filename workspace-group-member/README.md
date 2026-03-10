# workspace-group-member

Manages Databricks workspace group memberships - assigns users and service principals to groups.

## Purpose

This module is responsible for **group membership only**. It assigns existing users or service principals as members of existing groups. Group creation is handled by the `workspace-group` module.

## Directory Structure

```
workspace-group-member/
├── README.md
├── infra/
│   └── terraform/
│       └── main/
│           ├── aws-SE-99d097-databricks/
│           │   └── us-east-1/
│           │       └── terraform-workspace-group-member.auto.tfvars
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
        └── workspace-group-member/
            ├── README.md
            ├── go.mod
            ├── go.sum
            ├── workspace_group_member_test.go
            ├── test-reports/
            │   ├── junit.xml
            │   └── test-output.txt
            └── test.sh
```

## Usage

```hcl
module "workspace_group_members" {
  source = "../../../databricks-all-modules-main/modules/workspace-group-member"

  members = [
    {
      group_id  = module.workspace_groups.group_ids["data-engineers"]
      member_id = databricks_user.engineer1.id
    },
    {
      group_id  = module.workspace_groups.group_ids["data-analysts"]
      member_id = databricks_service_principal.analytics_sp.id
    },
  ]
}
```

## Inputs

| Name    | Description | Type | Required |
|---------|-------------|------|----------|
| members | List of group membership assignments (group_id + member_id) | `list(object)` | yes |

## Outputs

| Name           | Description |
|----------------|-------------|
| membership_ids | Map of membership key to resource ID |
| memberships    | Full map of created membership resources |
