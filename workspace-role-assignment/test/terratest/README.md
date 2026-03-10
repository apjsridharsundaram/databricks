# Terratest - workspace-role-assignment

Integration tests for the workspace-role-assignment Terraform module using [Terratest](https://terratest.gruntwork.io/).

## Prerequisites

- Go 1.21+
- Terraform 1.0+
- Databricks **account-level** credentials
- Pre-existing workspace ID and groups

## Running Tests

```bash
cd workspace-role-assignment/test/terratest/workspace-role-assignment
chmod +x test.sh
./test.sh
```

## Test Reports

Test reports are generated in `test-reports/`:
- `junit.xml` - JUnit XML format for CI integration
- `test-output.txt` - Raw test output
