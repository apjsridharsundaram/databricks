# Terratest - workspace-group-member

Integration tests for the workspace-group-member Terraform module using [Terratest](https://terratest.gruntwork.io/).

## Prerequisites

- Go 1.21+
- Terraform 1.0+
- Databricks workspace credentials
- Pre-existing groups and users in the workspace

## Running Tests

```bash
cd workspace-group-member/test/terratest/workspace-group-member
chmod +x test.sh
./test.sh
```

## Test Reports

Test reports are generated in `test-reports/`:
- `junit.xml` - JUnit XML format for CI integration
- `test-output.txt` - Raw test output
