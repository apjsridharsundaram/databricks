# workspace-group Terratest

Validates that the workspace-group module correctly creates Databricks groups for persona-based RBAC.

## Test Cases

- Creates groups with expected display names
- Validates group IDs are returned
- Validates group count matches input
- Validates entitlement flags are set correctly

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABRICKS_HOST` | Workspace URL |
| `DATABRICKS_TOKEN` | Workspace access token |
