terraform {
  required_version = ">= 1.0"

  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.0.0"
      configuration_aliases = [databricks.account, databricks.workspace]
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0"
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.9"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0"
    }
  }
}


