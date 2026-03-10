variable "display_name" {
  description = "The display name of the group (1.4: Use SCIM to sync groups from IdP for automatic provisioning)"
  type        = string
  
  validation {
    condition     = length(var.display_name) > 0 && length(var.display_name) <= 256
    error_message = "Group display name must be 1-256 characters."
  }
}

variable "allow_cluster_create" {
  description = "Allow the group to create clusters (1.11: Restrict cluster creation rights to necessary users only)"
  type        = bool
  default     = false
}

variable "allow_instance_pool_create" {
  description = "Allow the group to create instance pools"
  type        = bool
  default     = false
}

variable "databricks_sql_access" {
  description = "Allow the group to access Databricks SQL"
  type        = bool
  default     = false
}

variable "workspace_access" {
  description = "Allow the group to access the workspace"
  type        = bool
  default     = true
}

variable "external_id" {
  description = "External ID for SCIM provisioning (1.4: RECOMMENDED - enables automatic user/group sync from IdP)"
  type        = string
  default     = null
}

variable "force" {
  description = "Force the group to be created even if it already exists"
  type        = bool
  default     = false
}

variable "acl_principal_id" {
  description = "ACL principal ID"
  type        = string
  default     = null
}


