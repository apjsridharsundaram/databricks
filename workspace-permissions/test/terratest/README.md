# Terratest - workspace-permissions

Integration tests for the workspace-permissions Terraform module using [Terratest](https://terratest.gruntwork.io/).

## Prerequisites

- Go 1.21+
- Terraform 1.0+
- Databricks workspace credentials
- Pre-existing workspace resources (directories, clusters, etc.) to set permissions on

## Running Tests

```bash
cd workspace-permissions/test/terratest/workspace-permissions
chmod +x test.sh
./test.sh
```

## Test Reports

Test reports are generated in `test-reports/`:
- `junit.xml` - JUnit XML format for CI integration
- `test-output.txt` - Raw test output
