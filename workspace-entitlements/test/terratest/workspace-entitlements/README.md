# workspace-entitlements Terratest

Validates that the workspace-entitlements module correctly manages workspace-level capabilities for principals.

## Test Cases

- Assigns workspace_access entitlement to a group
- Assigns databricks_sql_access entitlement to a group
- Validates entitlement IDs are returned
- Validates entitlement flags match input

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABRICKS_HOST` | Workspace URL |
| `DATABRICKS_TOKEN` | Workspace access token |
