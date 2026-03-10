# workspace-group-member Terratest

Validates that the workspace-group-member module correctly assigns users and service principals to Databricks groups.

## Test Cases

- Creates memberships from name-based assignments
- Creates memberships from direct ID-based assignments
- Validates membership IDs are returned
- Validates membership count matches input

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABRICKS_HOST` | Workspace URL |
| `DATABRICKS_TOKEN` | Workspace access token |
