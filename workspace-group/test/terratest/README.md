# Terratest - workspace-group

Integration tests for the workspace-group Terraform module using [Terratest](https://terratest.gruntwork.io/).

## Prerequisites

- Go 1.21+
- Terraform 1.0+
- Databricks workspace credentials

## Running Tests

```bash
cd workspace-group/test/terratest/workspace-group
chmod +x test.sh
./test.sh
```

## Test Reports

Test reports are generated in `test-reports/`:
- `junit.xml` - JUnit XML format for CI integration
- `test-output.txt` - Raw test output
