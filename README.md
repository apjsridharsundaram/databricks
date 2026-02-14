# Databricks Catalog with Terraform

This repository contains a simple Terraform configuration to create a Unity Catalog catalog in Databricks.

## Files

- `versions.tf`: Terraform and Databricks provider configuration.
- `variables.tf`: Input variables.
- `main.tf`: Catalog resource definition.
- `outputs.tf`: Useful outputs after apply.

## Usage

1. Create a `terraform.tfvars` file:

```hcl
databricks_host  = "https://adb-1234567890123456.7.azuredatabricks.net"
databricks_token = "dapi..."
catalog_name     = "analytics"
catalog_comment  = "Analytics domain catalog"
# storage_root   = "s3://my-bucket/databricks/analytics"
# catalog_owner  = "data-admins"
# force_destroy  = false
```

2. Initialize and apply:

```bash
terraform init
terraform plan
terraform apply
```

## Notes

- Make sure Unity Catalog is enabled for your Databricks workspace/metastore.
- Use environment variables (for example `TF_VAR_databricks_token`) or a secret manager for production credentials.
