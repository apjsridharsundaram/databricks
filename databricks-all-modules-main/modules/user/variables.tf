variable "user_name" {
  description = "The username (email) of the user"
  type        = string
}

variable "display_name" {
  description = "The display name of the user"
  type        = string
  default     = null
}

variable "active" {
  description = "Whether the user is active"
  type        = bool
  default     = true
}

variable "allow_cluster_create" {
  description = "Allow the user to create clusters"
  type        = bool
  default     = false
}

variable "allow_instance_pool_create" {
  description = "Allow the user to create instance pools"
  type        = bool
  default     = false
}

variable "databricks_sql_access" {
  description = "Allow the user to access Databricks SQL"
  type        = bool
  default     = false
}

variable "workspace_access" {
  description = "Allow the user to access the workspace"
  type        = bool
  default     = true
}

variable "external_id" {
  description = "External ID for SCIM provisioning"
  type        = string
  default     = null
}

variable "force" {
  description = "Force the user to be created even if it already exists"
  type        = bool
  default     = false
}

variable "home" {
  description = "Home directory path for the user"
  type        = string
  default     = null
}

variable "repos" {
  description = "Repos directory path for the user"
  type        = string
  default     = null
}

variable "acl_principal_id" {
  description = "ACL principal ID"
  type        = string
  default     = null
}




