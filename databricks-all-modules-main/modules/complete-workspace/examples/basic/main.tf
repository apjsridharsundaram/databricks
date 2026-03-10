# Example: Complete Databricks Workspace - All-in-One

terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = ">= 1.0.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

# Account-level provider
provider "databricks" {
  alias      = "account"
  host       = "https://accounts.cloud.databricks.com"
  account_id = var.databricks_account_id
}

# Workspace-level provider (will be available after workspace creation)
provider "databricks" {
  alias = "workspace"
  host  = module.complete_workspace.workspace_url
}

provider "aws" {
  region = var.aws_region
}

# Create complete workspace with ONE module call!
module "complete_workspace" {
  source = "../../"

  providers = {
    databricks.account   = databricks.account
    databricks.workspace = databricks.workspace
  }

  # Required - Just these two!
  databricks_account_id = var.databricks_account_id
  workspace_name        = var.workspace_name

  # Optional - Everything else has smart defaults
  aws_region = var.aws_region

  # Enable all security features (defaults to true)
  enable_cmk                   = true
  create_metastore             = true
  create_default_catalog       = true
  configure_workspace_security = true
  create_cluster_policy        = true
  create_admin_group           = true

  # Optional IP restrictions
  # allowed_ip_addresses = ["1.2.3.4/32"]

  tags = {
    Environment = "example"
    ManagedBy   = "Terraform"
  }
}

# =============================================================================
# OUTPUTS
# =============================================================================

output "workspace_url" {
  description = "Access your Databricks workspace here"
  value       = module.complete_workspace.workspace_url
}

output "workspace_id" {
  description = "Workspace ID"
  value       = module.complete_workspace.workspace_id
}

output "metastore_id" {
  description = "Unity Catalog Metastore ID"
  value       = module.complete_workspace.metastore_id
}

output "catalog_name" {
  description = "Default catalog name"
  value       = module.complete_workspace.default_catalog_name
}

output "security_info" {
  description = "Security configuration summary"
  value = {
    cmk_encryption_enabled    = module.complete_workspace.managed_services_cmk_id != null
    unity_catalog_enabled     = module.complete_workspace.metastore_id != null
    security_settings_applied = true
    cluster_policy_created    = module.complete_workspace.secure_cluster_policy_id != null
    admin_group_created       = module.complete_workspace.admin_group_id != null
  }
}

output "aws_infrastructure" {
  description = "AWS infrastructure details"
  value = {
    vpc_id             = module.complete_workspace.vpc_id
    s3_bucket          = module.complete_workspace.s3_bucket_name
    security_group_id  = module.complete_workspace.security_group_id
    cross_account_role = module.complete_workspace.cross_account_role_arn
  }
}

