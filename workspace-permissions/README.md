# workspace-permissions

Manages Databricks object-level permissions (ACLs) for workspace resources such as notebooks, jobs, clusters, warehouses, directories, and more.

## Purpose

This module controls **object-level access control** - what a principal can do with a specific resource. This is different from:
- **Role Assignment** (account-level: USER/ADMIN workspace access)
- **Entitlements** (workspace capabilities like sql_access, cluster_create)

## Directory Structure

```
workspace-permissions/
├── README.md
├── infra/
│   └── terraform/
│       └── main/
│           ├── aws-SE-99d097-databricks/
│           │   └── us-east-1/
│           │       └── terraform-workspace-permissions.auto.tfvars
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
        └── workspace-permissions/
            ├── README.md
            ├── go.mod
            ├── go.sum
            ├── workspace_permissions_test.go
            ├── test-reports/
            │   ├── junit.xml
            │   └── test-output.txt
            └── test.sh
```

## Supported Resource Types

| Resource Type | Identifier Field | Permission Levels |
|---------------|-----------------|-------------------|
| Cluster | `cluster_id` | CAN_ATTACH_TO, CAN_RESTART, CAN_MANAGE |
| Cluster Policy | `cluster_policy_id` | CAN_USE |
| Directory | `directory_path` | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| Job | `job_id` | CAN_VIEW, CAN_MANAGE_RUN, IS_OWNER, CAN_MANAGE |
| Notebook | `notebook_path` | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| Pipeline | `pipeline_id` | CAN_VIEW, CAN_RUN, CAN_MANAGE, IS_OWNER |
| Repo | `repo_path` | CAN_READ, CAN_RUN, CAN_EDIT, CAN_MANAGE |
| SQL Warehouse | `sql_endpoint_id` | CAN_USE, CAN_MONITOR, CAN_MANAGE, IS_OWNER |
| Experiment | `experiment_id` | CAN_READ, CAN_EDIT, CAN_MANAGE |
| Model | `registered_model_id` | CAN_READ, CAN_EDIT, CAN_MANAGE_STAGING_VERSIONS, CAN_MANAGE_PRODUCTION_VERSIONS, CAN_MANAGE |
| Token | `authorization` | CAN_USE, CAN_MANAGE |

## Usage

```hcl
module "workspace_permissions" {
  source = "../../../databricks-all-modules-main/modules/workspace-permissions"

  permission_assignments = [
    {
      resource_key   = "shared-notebooks"
      directory_path = "/Shared"
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
  ]
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| permission_assignments | List of permission assignments with resource identifier and ACL list | `list(object)` | yes |

## Outputs

| Name | Description |
|------|-------------|
| permission_ids | Map of resource_key to permission resource ID |
| permissions | Full map of created permission resources |
