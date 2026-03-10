# workspace-role-assignment Terratest

Validates that the workspace-role-assignment module correctly assigns principals to a Databricks workspace with USER or ADMIN roles.

## Test Cases

- Assigns a group with USER role
- Assigns a group with ADMIN role
- Validates assignment IDs are returned
- Validates permissions validation (only USER/ADMIN accepted)

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABRICKS_HOST` | Account console URL |
| `DATABRICKS_ACCOUNT_ID` | Account ID |
| `DATABRICKS_TOKEN` | Account-level access token |
| `TEST_WORKSPACE_ID` | Workspace ID for testing |
