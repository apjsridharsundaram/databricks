# Terratest - workspace-entitlements

Integration tests for the workspace-entitlements Terraform module using [Terratest](https://terratest.gruntwork.io/).

## Prerequisites

- Go 1.21+
- Terraform 1.0+
- Databricks workspace credentials
- Pre-existing groups in the workspace

## Running Tests

```bash
cd workspace-entitlements/test/terratest/workspace-entitlements
chmod +x test.sh
./test.sh
```

## Test Reports

Test reports are generated in `test-reports/`:
- `junit.xml` - JUnit XML format for CI integration
- `test-output.txt` - Raw test output
