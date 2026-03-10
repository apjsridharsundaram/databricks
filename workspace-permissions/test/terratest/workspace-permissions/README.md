# workspace-permissions Terratest

Validates that the workspace-permissions module correctly manages object-level ACLs on workspace resources.

## Test Cases

- Assigns directory permissions to a group
- Assigns token management permissions
- Validates permission IDs are returned
- Validates ACL entries match input

## Environment Variables

| Variable | Description |
|----------|-------------|
| `DATABRICKS_HOST` | Workspace URL |
| `DATABRICKS_TOKEN` | Workspace access token |
