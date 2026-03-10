# =============================================================================
# Example Root Module: Workspace Authorization
# Demonstrates usage of all five workspace authorization modules.
#
# This file lives in the main Terraform layer and shows how to compose the
# modules for an enterprise Databricks workspace on AWS.
# =============================================================================

# =============================================================================
# TERRAFORM CONFIGURATION
# =============================================================================

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
  #   key     = "databricks/us-east-1/terraform.tfstate"
  #   region  = "us-east-1"
  #   encrypt = true
  # }
}

# =============================================================================
# PROVIDER CONFIGURATION
# =============================================================================

# Workspace-level provider (for groups, entitlements, permissions)
provider "databricks" {
  alias = "workspace"
  # host  = var.databricks_workspace_url
  # token = var.databricks_workspace_token
}

# Account-level provider (for workspace role assignments)
provider "databricks" {
  alias = "account"
  # host       = "https://accounts.cloud.databricks.com"
  # account_id = var.databricks_account_id
}

# =============================================================================
# VARIABLES
# =============================================================================

variable "databricks_workspace_id" {
  description = "The Databricks workspace ID"
  type        = string
}

variable "databricks_account_id" {
  description = "The Databricks account ID"
  type        = string
  default     = ""
}

# =============================================================================
# MODULE 1: WORKSPACE GROUPS
# Creates persona-based groups for RBAC.
# =============================================================================

module "workspace_groups" {
  source = "../../../../databricks-all-modules-main/modules/workspace-group"

  providers = {
    databricks = databricks.workspace
  }

  groups = [
    {
      display_name   = "workspace-admins"
      workspace_access = true
    },
    {
      display_name   = "data-engineers"
      workspace_access = true
    },
    {
      display_name   = "data-analysts"
      workspace_access = true
    },
    {
      display_name   = "data-scientists"
      workspace_access = true
    },
  ]
}

# =============================================================================
# MODULE 2: WORKSPACE GROUP MEMBERS
# Assigns users and service principals to groups.
# Uncomment and populate with actual user/SP IDs.
# =============================================================================

# module "workspace_group_members" {
#   source = "../../../../databricks-all-modules-main/modules/workspace-group-member"
#
#   providers = {
#     databricks = databricks.workspace
#   }
#
#   members = [
#     {
#       group_id  = module.workspace_groups.group_ids["workspace-admins"]
#       member_id = "<admin-user-id>"
#     },
#     {
#       group_id  = module.workspace_groups.group_ids["data-engineers"]
#       member_id = "<engineer-user-id>"
#     },
#     {
#       group_id  = module.workspace_groups.group_ids["data-analysts"]
#       member_id = "<analyst-user-id>"
#     },
#     {
#       group_id  = module.workspace_groups.group_ids["data-scientists"]
#       member_id = "<scientist-user-id>"
#     },
#   ]
# }

# =============================================================================
# MODULE 3: WORKSPACE ROLE ASSIGNMENT
# Assigns groups to the workspace at the account level (USER or ADMIN role).
# Uses the account-level provider.
# =============================================================================

module "workspace_role_assignment" {
  source = "../../../../databricks-all-modules-main/modules/workspace-role-assignment"

  providers = {
    databricks = databricks.account
  }

  workspace_id = var.databricks_workspace_id

  group_role_assignments = [
    {
      group_name  = "workspace-admins"
      permissions = ["ADMIN"]
    },
    {
      group_name  = "data-engineers"
      permissions = ["USER"]
    },
    {
      group_name  = "data-analysts"
      permissions = ["USER"]
    },
    {
      group_name  = "data-scientists"
      permissions = ["USER"]
    },
  ]

  # Direct user assignments (use sparingly)
  user_role_assignments = []

  # Service principal assignments
  sp_role_assignments = []

  depends_on = [module.workspace_groups]
}

# =============================================================================
# MODULE 4: WORKSPACE ENTITLEMENTS
# Manages workspace capabilities per group (SQL access, cluster create, etc.).
# =============================================================================

module "workspace_entitlements" {
  source = "../../../../databricks-all-modules-main/modules/workspace-entitlements"

  providers = {
    databricks = databricks.workspace
  }

  group_entitlements = [
    {
      group_id                   = module.workspace_groups.group_ids["workspace-admins"]
      workspace_access           = true
      databricks_sql_access      = true
      allow_cluster_create       = true
      allow_instance_pool_create = true
    },
    {
      group_id              = module.workspace_groups.group_ids["data-engineers"]
      workspace_access      = true
      databricks_sql_access = true
      allow_cluster_create  = true
    },
    {
      group_id              = module.workspace_groups.group_ids["data-analysts"]
      workspace_access      = true
      databricks_sql_access = true
    },
    {
      group_id              = module.workspace_groups.group_ids["data-scientists"]
      workspace_access      = true
      databricks_sql_access = true
      allow_cluster_create  = true
    },
  ]

  depends_on = [module.workspace_groups]
}

# =============================================================================
# MODULE 5: WORKSPACE PERMISSIONS
# Manages object-level permissions (notebooks, jobs, clusters, warehouses, etc.).
# Uncomment and populate with actual resource IDs.
# =============================================================================

# module "workspace_permissions" {
#   source = "../../../../databricks-all-modules-main/modules/workspace-permissions"
#
#   providers = {
#     databricks = databricks.workspace
#   }
#
#   permission_assignments = [
#     # Shared notebook directory permissions
#     {
#       resource_key   = "shared-notebooks"
#       directory_path = "/Shared"
#       access_control_list = [
#         {
#           group_name       = "data-engineers"
#           permission_level = "CAN_EDIT"
#         },
#         {
#           group_name       = "data-analysts"
#           permission_level = "CAN_READ"
#         },
#         {
#           group_name       = "data-scientists"
#           permission_level = "CAN_RUN"
#         },
#       ]
#     },
#     # Token management permissions
#     {
#       resource_key  = "token-management"
#       authorization = "tokens"
#       access_control_list = [
#         {
#           group_name       = "workspace-admins"
#           permission_level = "CAN_MANAGE"
#         },
#         {
#           group_name       = "data-engineers"
#           permission_level = "CAN_USE"
#         },
#       ]
#     },
#     # SQL warehouse permissions
#     # {
#     #   resource_key    = "analytics-warehouse"
#     #   sql_endpoint_id = "<warehouse-id>"
#     #   access_control_list = [
#     #     {
#     #       group_name       = "data-analysts"
#     #       permission_level = "CAN_USE"
#     #     },
#     #     {
#     #       group_name       = "workspace-admins"
#     #       permission_level = "CAN_MANAGE"
#     #     },
#     #   ]
#     # },
#   ]
#
#   depends_on = [module.workspace_groups]
# }

# =============================================================================
# OUTPUTS
# =============================================================================

output "group_ids" {
  description = "Map of group display_name to group ID"
  value       = module.workspace_groups.group_ids
}

output "group_names" {
  description = "List of created group names"
  value       = module.workspace_groups.group_names
}

output "role_assignment_group_ids" {
  description = "Map of group role assignment IDs"
  value       = module.workspace_role_assignment.group_assignment_ids
}

output "entitlement_group_ids" {
  description = "Map of group entitlement IDs"
  value       = module.workspace_entitlements.group_entitlement_ids
}
