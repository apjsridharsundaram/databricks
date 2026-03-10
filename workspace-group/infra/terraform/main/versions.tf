terraform {
  required_version = ">= 1.0"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.0.0"
    }
  }

  # Uncomment and configure for your backend:
  # backend "s3" {
  #   bucket  = "my-terraform-state"
  #   key     = "databricks/workspace-group/terraform.tfstate"
  #   region  = "us-east-1"
  #   encrypt = true
  # }
}
